if Config.Inventory ~= 'tgiann-inventory' then return end

Inventory = {
    openInventory = function(invType, data)
        TriggerServerEvent('p_policejob/inventory/openInventory', invType, data)
    end,
    getItemCount = function(itemName)
        return lib.callback.await('p_policejob/inventory/getItemCount', false, itemName)
    end,
    useItem = function(data, cb)
        cb(true)
    end,
}