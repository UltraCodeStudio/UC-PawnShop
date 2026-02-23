if Config.Inventory ~= 'codem-inventory' then return end

Inventory = {
    openInventory = function(invType, data)
        if invType == 'stash' then
            if data.owner then
                TriggerServerEvent("inventory:server:OpenInventory", "stash", data.id..'_'..data.owner, {
                    maxweight = 250000,
                    slots = 100,
                })
            else
                TriggerServerEvent("inventory:server:OpenInventory", "stash", data, {
                    maxweight = 250000,
                    slots = 100,
                })
            end
        elseif invType == 'player' then
            TriggerServerEvent('codem-inventory:server:robplayer', data)
        else
            TriggerServerEvent('p_policejob/inventory/openInventory', invType, data)
        end
    end,
    getItemCount = function(itemName)
        return lib.callback.await('p_policejob/inventory/getItemCount', false, itemName)
    end,
    useItem = function(data, cb)
        cb(true)
    end,
}