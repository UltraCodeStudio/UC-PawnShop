if Config.Inventory ~= 'ox_inventory' then return end

Inventory = {
    getItemCount = function(playerId, itemName)
        return exports['ox_inventory']:Search(playerId, 'count', itemName)
    end,
    addPlayerItem = function(playerId, itemName, itemCount, metadata)
        exports['ox_inventory']:AddItem(playerId, itemName, itemCount, metadata)
    end,
    removePlayerItem = function(playerId, itemName, itemCount, metadata)
        return exports['ox_inventory']:RemoveItem(playerId, itemName, itemCount, metadata)
    end,
    registerStash = function(name, label, slots, weight, owner, job, coords)
        exports['ox_inventory']:RegisterStash(name, label, 100, weight, owner, job, coords)
    end,
    getInventoryItems = function(playerId)
        return exports['ox_inventory']:GetInventoryItems(playerId)
    end,
    clearInventory = function(inventory, keep)
        exports['ox_inventory']:ClearInventory(inventory, keep or false)
    end,
    getItemSlot = function(playerId, slot)
        return exports['ox_inventory']:GetSlot(playerId, slot)
    end,
    registerShop = function(shopName, shopData)
        exports['ox_inventory']:RegisterShop(shopName, shopData)
    end,
    addStashItem = function(stashData, itemName, itemCount, metadata, slot)
        exports['ox_inventory']:AddItem(stashData, itemName, itemCount, metadata, slot)
    end,
}