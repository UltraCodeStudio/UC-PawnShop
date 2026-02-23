if Config.Inventory ~= 'qs-inventory' then return end

RegisterNetEvent('policejob/registerStash', function(stashId, slots, weight)
    exports['qs-inventory']:RegisterStash(source, stashId, slots, weight)
end)

Inventory = {
    getItemCount = function(playerId, itemName)
        return exports['qs-inventory']:GetItemTotalAmount(playerId, itemName)
    end,
    addPlayerItem = function(playerId, itemName, itemCount, metadata, slot)
        exports['qs-inventory']:AddItem(playerId, itemName, itemCount, slot, metadata)
    end,
    removePlayerItem = function(playerId, itemName, itemCount, metadata, slot)
        exports['qs-inventory']:RemoveItem(playerId, itemName, itemCount, slot, metadata)
    end,
    registerStash = function(name, label, slots, weight, owner, job, coords)
    end,
    getInventoryItems = function(playerId)
        local items = exports['qs-inventory']:GetInventory(playerId) or {}
        for i = 1, #items, 1 do
            if items[i] and items[i].info then
                items[i].metadata = items[i].info
            end
        end
        return items
    end,
    clearInventory = function(inventory, keep)
        exports['qs-inventory']:ClearInventory(inventory)
    end,
    getItemSlot = function(playerId, slot)
        local itemSlot = nil
        local inventory = exports['qs-inventory']:GetInventory(playerId)
        for k, v in pairs(inventory) do
            if v.slot == slot then
                itemSlot = v
                break
            end
        end

        return itemSlot
    end,
    registerShop = function(shopName, shopData)
    end,
    addStashItem = function(stashData, itemName, itemCount, metadata, slot)
        exports['ps-inventory']:AddItemIntoStash(stashData.id..'_'..stashData.owner, itemName, itemCount, slot, metadata)
    end,
}

RegisterNetEvent('p_policejob/inventory/removeItem', function(itemName, itemCount)
    Inventory.removePlayerItem(source, itemName, itemCount)
end)

local itemsFunctions = {
    ['photo'] = function(playerId, item)
        if item and item.info then
            TriggerClientEvent('p_policejob/client_camera/ShowPhoto', playerId, item.info.photoURL)
        end
    end,
    ['body_cam'] = function(playerId, item)
        exports['p_policejob']:useBodyCamItem(playerId)
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
}

Citizen.CreateThread(function()
    if Config.Framework == 'ESX' then
        local ESX = exports['es_extended']:getSharedObject()
        for itemName, itemFunction in pairs(itemsFunctions) do
            ESX.RegisterUsableItem(itemName, itemFunction)
        end
    elseif Config.Framework == 'QB' then
        local QBCore = exports['qb-core']:GetCoreObject()
        for itemName, itemFunction in pairs(itemsFunctions) do
            QBCore.Functions.CreateUseableItem(itemName, itemFunction)
        end
    end
end)