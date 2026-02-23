local spawnedPeds = {}

Citizen.CreateThread(function ()
    Citizen.Wait(2000)
    for i, k in pairs(Config.SellerPeds) do
        local ped = SpawnCustomPed(k.model,k.coords,k.heading, k.scenario)
        
        
        exports.ox_target:addLocalEntity(ped, {
        {
            label = 'Sell Items',
            icon = 'fa-solid fa-comments',
            groups = k.jobs,
            onSelect = function()
                OpenPawnMenu(k.dropOffVehicle, k.dropOffVehicleSpawn)
            end
        }
        })
        table.insert(spawnedPeds, ped)


        CreateBlip(k.coords,351,0.8,5,"Used-A-Ton",false)


    end
end)

AddEventHandler('onResourceStop', function(resourceName)
  if (GetCurrentResourceName() ~= resourceName) then
    return
  end
    for i, k in pairs(spawnedPeds) do
        DeletePed(k)
    end
end)