if Config.Inventory ~= 'qs-inventory' then return end

local notRemovable = {
    ['photo'] = true,
    ['camera'] = true,
    ['police_radar'] = true
}

Inventory = {
    openInventory = function(invType, data, items)
        if invType == 'stash' then
            if data.owner then   
                TriggerServerEvent('policejob/registerStash', data.id..'_'..data.owner, 50, 10000)
            else
                TriggerServerEvent('policejob/registerStash', data, 50, 10000)
            end
        elseif invType == 'shop' then
            local shopData = {
                label = data.type,
                items = items
            }
            for i = 1, #shopData.items, 1 do
                shopData.items[i].slot = i
                shopData.items[i].amount = 999999
            end
            TriggerServerEvent("inventory:server:OpenInventory", "shop", data.type..'_'..data.id, shopData)
        elseif invType == 'player' then
            TriggerServerEvent("inventory:server:OpenInventory", "otherplayer", data)
            TriggerEvent("inventory:client:SetCurrentStash", "otherplayer", data)
        end
    end,
    getItemCount = function(itemName)
        return exports['qs-inventory']:Search(itemName)
    end,
    useItem = function(data, cb)
        if data and data.useable then
            if not notRemovable[data.name] then
                TriggerServerEvent('p_policejob/inventory/removeItem', data.name, 1)
            end
        end
        cb(true)
    end,
}