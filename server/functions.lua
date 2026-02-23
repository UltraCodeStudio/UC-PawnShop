function GetFramework()
    if GetResourceState('qbx_core') == 'started' then return 'qbx' end
    if GetResourceState('qb-core') == 'started' then return 'qbcore' end
    if GetResourceState('es_extended') == 'started' then return 'esx' end
    return nil
end

function HasItemCheck(src,item, ammount)
    local itemCount = Inventory.getItemCount(src, item)
    if itemCount >= ammount then
        return true
    else
        return false
    end
end

lib.callback.register('dn-pawnshop:basketItemCheck', function(src,item,ammount)
    if HasItemCheck(src,item,ammount) then
        Inventory.removePlayerItem(src, item, ammount)
        return true
    end
    return false
    
end)



---@param income number
RegisterNetEvent('dn-pawnshop:server:functions:pay', function(income)
    local src = source
    

    local framework = GetFramework()
    local account = Config.PaymentAccount or 'cash'

    if framework == 'qbx' then
        local player = exports.qbx_core:GetPlayer(src)
        if player then
            player.Functions.AddMoney(account, income, 'pawnshop-payment')
        end

    elseif framework == 'qbcore' then
        local QBCore = exports['qb-core']:GetCoreObject()
        local player = QBCore.Functions.GetPlayer(src)
        if player then
            player.Functions.AddMoney(account, income, 'pawnshop-payment')
        end

    elseif framework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer then
            xPlayer.addAccountMoney(account, income)
        end
    end
end)