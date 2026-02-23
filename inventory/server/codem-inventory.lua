if Config.Inventory ~= 'codem-inventory' then return end

local ESX, QBCore = nil, nil
if Config.Framework == 'ESX' then
    ESX = exports['es_extended']:getSharedObject()
elseif Config.Framework == 'QB' then
    QBCore = exports['qb-core']:GetCoreObject()
end

Inventory = {
    getItemCount = function(playerId, itemName)
        return exports['codem-inventory']:GetItemsTotalAmount(playerId, itemName)
    end,
    addPlayerItem = function(playerId, itemName, itemCount, metadata, slot)
        exports['codem-inventory']:AddItem(playerId, itemName, itemCount, slot, metadata)
    end,
    removePlayerItem = function(playerId, itemName, itemCount, metadata, slot)
        exports['codem-inventory']:RemoveItem(playerId, itemName, itemCount, slot, metadata) -- metadata = slot
    end,
    registerStash = function(name, label, slots, weight, owner, job, coords)
    end,
    getInventoryItems = function(playerId)
        return exports['codem-inventory']:GetInventory(playerId)
    end,
    clearInventory = function(inventory, keep)
        if type(inventory) == 'string' then
            exports['codem-inventory']:UpdateStash(inventory, {})
        else
            exports['codem-inventory']:ClearInventory(inventory)
        end
    end,
    getItemSlot = function(playerId, slot)
        local itemSlot = exports['codem-inventory']:GetItemBySlot(playerId, slot)
        if itemSlot.info then
            itemSlot.metadata = itemSlot.info
        end
        return itemSlot
    end,
    registerShop = function(shopName, shopData)
    end,
    addStashItem = function(stashData, itemName, itemCount, metadata, slot)
        exports['codem-inventory']:AddItem(stashData.id..'_'..stashData.owner, itemName, itemCount, slot, metadata)
    end,
}

lib.callback.register('p_policejob/inventory/getItemCount', function(source, itemName)
    return Inventory.getItemCount(source, itemName)
end)

RegisterNetEvent('p_policejob/inventory/openInventory', function(invType, data)
    if invType == 'player' then
        TriggerClientEvent('codem-inventory:client:robplayer', source, data)
    elseif invType == 'shop' then
        TriggerClientEvent('codem-inventory:openshop', source, data.type)
    end
end)

local itemsFunctions = {
    ['handcuffs'] = function(playerId)
        TriggerClientEvent('p_policejob/useHandcuffs', playerId)
    end,
    ['photo'] = function(playerId, item)
        local metadata = item.metadata or item.info
        if not metadata then return end
        TriggerClientEvent('p_policejob/client_camera/ShowPhoto', playerId, metadata.photoURL)
    end,
    ['camera'] = function(playerId)
        TriggerClientEvent('p_policejob/client_camera/useCamera', playerId)
    end,
    ['gps'] = function(playerId, item)
        TriggerClientEvent('p_policejob/client_gps/UseGPS', playerId)
    end,
    ['body_cam'] = function(playerId, item)
        exports['p_policejob']:useBodyCamItem(playerId)
    end,
    ['vest_strong'] = function(playerId, item)
        TriggerClientEvent('p_policejob/use_vest/vest_strong', playerId)
        Inventory.removePlayerItem(playerId, 'vest_strong', 1)
    end,
    ['vest_normal'] = function(playerId, item)
        TriggerClientEvent('p_policejob/use_vest/vest_normal', playerId)
        Inventory.removePlayerItem(playerId, 'vest_normal', 1)
    end,
    ['player_clothes'] = function(playerId, item)
        local result = lib.callback.await('p_policejob/client_divingsuit/UseClothes', playerId)
        if result then
            Inventory.removePlayerItem(playerId, 'player_clothes', 1)
            Inventory.addPlayerItem(playerId, 'police_diving_suit', 1)
        end
    end,
    ['police_diving_suit'] = function(playerId, item)
        local result = lib.callback.await('p_policejob/client_divingsuit/UseSuit', playerId)
        if result then
            Inventory.removePlayerItem(playerId, 'police_diving_suit', 1)
            Inventory.addPlayerItem(playerId, 'player_clothes', 1)
        end
    end,
    ['police_radar'] = function(playerId, item)
        TriggerClientEvent('p_policejob/toggleHandRadar', playerId)
    end,
    ['spike_strip'] = function(playerId, item)
        local result = lib.callback.await('p_policejob/useSpikeStrip', playerId)
        if result then
            Inventory.removePlayerItem(playerId, 'spike_strip', 1)
        end
    end
}

Citizen.CreateThread(function()
    for itemName, itemFunction in pairs(itemsFunctions) do
        if QBCore then
            QBCore.Functions.CreateUseableItem(itemName, itemFunction)
        elseif ESX then
            ESX.RegisterUsableItem(itemName, itemFunction)
        end
    end
end)