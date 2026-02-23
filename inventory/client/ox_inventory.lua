if Config.Inventory ~= 'ox_inventory' then return end

Inventory = {
    openInventory = function(invType, data)
        exports['ox_inventory']:openInventory(invType, data)
    end,
    getItemCount = function(itemName)
        return exports['ox_inventory']:Search('count', itemName)
    end,
    useItem = function(data, cb)
        exports['ox_inventory']:useItem(data, cb)
    end,
}