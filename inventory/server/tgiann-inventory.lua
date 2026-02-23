if Config.Inventory ~= 'tgiann-inventory' then return end

Inventory = {
    getItemCount = function(playerId, itemName)
        return exports['tgiann-inventory']:GetItemCount(playerId, itemName)
    end,
    addPlayerItem = function(playerId, itemName, itemCount, metadata)
        exports['tgiann-inventory']:AddItem(playerId, itemName, itemCount, nil, metadata)
    end,
    removePlayerItem = function(playerId, itemName, itemCount, metadata)
        exports['tgiann-inventory']:RemoveItem(playerId, itemName, itemCount, nil, metadata) -- metadata = slot
    end,
    registerStash = function(name, label, slots, weight, owner, job, coords)
    end,
    getInventoryItems = function(playerId)
        return exports["tgiann-inventory"]:GetPlayerItems(playerId)
    end,
    clearInventory = function(inventory, keep)
        if type(inventory) == 'string' then
            exports['tgiann-inventory']:ClearStash(inventory)
        else
            exports['tgiann-inventory']:ClearInventory(inventory)
        end
    end,
    getItemSlot = function(playerId, slot)
        local itemSlot = exports['tgiann-inventory']:GetItemBySlot(playerId, slot)
        return itemSlot
    end,
    registerShop = function(shopName, shopData)
        for i = 1, #shopData.inventory, 1 do
            shopData.inventory[i].amount = 1
            if shopData.inventory[i].name:find('WEAPON_') then
                shopData.inventory[i].type = 'weapon'
            else
                shopData.inventory[i].type = 'item'
            end
        end
        exports["tgiann-inventory"]:RegisterShop(shopName, shopData.inventory[i])
    end,
    addStashItem = function(stashData, itemName, itemCount, metadata, slot)
        exports["tgiann-inventory"]:AddItem(stashData.id..'_'..stashData.owner, itemName, itemCount, slot, metadata, false)
    end,
}

lib.callback.register('p_policejob/inventory/getItemCount', function(source, itemName)
    return Inventory.getItemCount(source, itemName)
end)

RegisterNetEvent('p_policejob/inventory/openInventory', function(invType, data)
    if invType == 'stash' then
        if data.owner then
            exports['tgiann-inventory']:OpenInventory(source, "stash", data.id..'_'..data.owner)
        else
            exports['tgiann-inventory']:OpenInventory(source, "stash", data)
        end
    elseif invType == 'player' then
        exports["tgiann-inventory"]:OpenInventoryById(source, data)
    elseif invType == 'shop' then
        exports["tgiann-inventory"]:OpenShop(source, data.type)
    end
end)