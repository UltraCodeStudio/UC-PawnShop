
--Whether the player is currently on a job
---@type boolean
currentJob = false

---@type table
basket = {}

---@type boolean
Isinside = false

---@param model string Ped model (e.g. 's_m_m_security_01')
---@param coords vector3 Spawn coordinates
---@param heading number Heading the ped faces
---@param scenario? string Scenario name (e.g. 'WORLD_HUMAN_CLIPBOARD')
---@param propData? table Props: {model = string, bone = number, pos = vector3, rot = vector3}
---@return number ped The created ped entity
function SpawnCustomPed(model, coords, heading, scenario)
    
    lib.requestModel(model)
    local modelHash = type(model) == 'string' and joaat(model) or model
    local ped = CreatePed(4, modelHash, coords.x, coords.y, coords.z, heading, false, true)
    SetEntityHeading(ped, heading)
    SetPedFleeAttributes(ped, 0, false)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)
    -- Start scenario if provided
    if scenario then
        TaskStartScenarioInPlace(ped, scenario, 0, true)
    end
    SetModelAsNoLongerNeeded(modelHash)
    return ped
end

---Create A blip on the map
---@param coords any
---@param sprite any
---@param scale any
---@param color any
---@param label any
---@return integer
function CreateBlip(coords, sprite, scale, color, label, setRoute)
    
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, sprite) -- Set blip icon
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, scale) -- Set blip scale
    SetBlipColour(blip, color) -- Set blip color
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(label) -- Set blip label
    EndTextCommandSetBlipName(blip)
    if setRoute == false then return blip end
    SetBlipRoute(blip, true)
    return blip
    
end

---@param entity any
---@param sprite integer Blip icon ID       
---@param scale number Blip scale
---@param color integer Blip color
---@param label string Blip label
---@return integer blip
function CreateBlipEntity(entity, sprite, scale, color, label)
    if not DoesEntityExist(entity) then
        print("Entity does not exist for blip creation.")
        return nil
    end
    local blip = AddBlipForEntity(entity)
    SetBlipSprite(blip, sprite) -- Set blip icon
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, scale) -- Set blip scale
    SetBlipColour(blip, color) -- Set blip color
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(label) -- Set blip label
    EndTextCommandSetBlipName(blip)
    SetBlipAsShortRange(blip, true)
    return blip
end

---Send Notification
---@param title string
---@param description string
---@param type? string
function Notify(title, description, type)
    lib.notify({
        title = title,
        description = description,
        type = type or "info",
        position = "top-right",
        duration = 5000
    })
end

---@param old number
---@param new number    
---@return number percent change
function GetPercentageChange(old, new)
    
    if old == 0 then
        return 0 -- Avoid division by zero
    end
    return ((new - old) / old) * 100
end

---Spawns a vehicle
---@param model string Vehicle model name (e.g. 'mule')
---@param coords vector3 Spawn coordinates
---@param heading number Heading of the vehicle
---@return number vehicle The created vehicle entity
function SpawnVehicle(model, coords, heading)
    lib.requestModel(model)
    local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, false)
    SetVehicleOnGroundProperly(vehicle)
    SetEntityAsMissionEntity(vehicle, true, true)
    SetModelAsNoLongerNeeded(model)
    return vehicle
end

---@param vehicle number
function GiveKeys(vehicle)
    if not DoesEntityExist(vehicle) then return end

    local plate = GetVehicleNumberPlateText(vehicle)
    local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
    local src = PlayerPedId()

    -- QS Vehiclekeys
    if GetResourceState('qs-vehiclekeys') == 'started' then
        -- Give keys to the player
        exports['qs-vehiclekeys']:GiveKeys(plate, model, true)

    -- Wasabi Carlock
    elseif GetResourceState('wasabi_carlock') == 'started' then
        TriggerServerEvent('wasabi_carlock:addTempKeys', plate)

    -- CD Garage (basic key trigger)
    elseif GetResourceState('cd_garage') == 'started' then
        TriggerEvent('cd_garage:AddKeys', vehicle)

    -- Default fallback (custom logic or placeholder)
    else
        -- Send to your own server event or notify the player
        TriggerEvent('vehiclekeys:client:SetOwner', plate) -- If this exists
        print(('[DEBUG] Gave fallback keys for plate: %s'):format(plate))
    end

    
    Notify("Vehicle Keys", ('You received keys for [%s]'):format(plate), "success")
end


---@param zone table Zone object
---@param income number Income from the sale        
---@param vehicle number Vehicle entity used for drop-off
function FinishDropOff(income, vehicle, dropOffVehicle, dropOffVehicleSpawn, blip)
   
    if not DoesEntityExist(vehicle) then
        Notify("Pawn Shop", "The drop-off vehicle is no longer available.", "error")
        return
    end
    
    DropOffVehicle(income,vehicle, dropOffVehicle, dropOffVehicleSpawn, blip)
    
    
end



function DropOffVehicle(income,vehicle, dropOffVehicle, dropOffVehicleSpawn, blip)

    local zone = lib.zones.sphere({
        coords = dropOffVehicleSpawn,
        radius = 4.0,
        debug = true,
        inside = function(zone)
            if IsControlJustReleased(0, 38) then -- E key
                Notify("Pawn Shop", "You have dropped off the vehicle.", "success")
                RemoveBlip(blip)
                Notify("Pawn Shop", "You sold your items for £" .. income, "success")
                DeleteVehicle(vehicle)
                TriggerServerEvent('dn-pawnshop:server:functions:pay', income)
                currentJob = false
                zone:remove()
            end
        end,
    })
    
end



function PlayAnimation()
    
    local ped = PlayerPedId()
    lib.requestAnimDict("missexile3")
    
    TaskPlayAnim(ped, "missexile3", "ex03_dingy_search_case_b_michael", 8.0, -8.0, -1, 50, 0.0, false, false, false)
end

---@param ped number
---@param model string
function PutObjectInHands(ped, model)
    if not model then model = "ng_proc_box_01a" end
    lib.requestModel(model)
    local object = CreateObject(model, 0.0, 0.0, 0.0, true, true, false)
    AttachEntityToEntity(object, ped, GetPedBoneIndex(ped, 28422), 0.1, 0.0, 0.0, 0.0, 180.0, 180.0, true, true, false, true, 1, true)
    PlayAnimation()

    return object
end

---comment
---@param ped number
---@param object number
function RemoveObjectFromHands(ped, object)
    if DoesEntityExist(object) then
        DetachEntity(object, true, true)
        DeleteObject(object)
    end
    ClearPedTasks(ped)
end

function TravelBack(income, vehicle, dropOffVehicle, dropOffVehicleSpawn)
    local blip = CreateBlip(dropOffVehicleSpawn, 1, 0.7, 2, "Drop Off Location")
    FinishDropOff(income, vehicle, dropOffVehicle, dropOffVehicleSpawn, blip) -- Finish the drop-off if no items left
end

function StartUnloading(config,income, vehicle, basket, dropOffVehicle, dropOffVehicleSpawn)
    
    local holdingObject = nil
    local unloadBasket = basket

    
    exports.ox_target:addLocalEntity(vehicle, {
        {
            label = 'Unload Items',
            icon = 'fa-solid fa-boxes-stacked',
            onSelect = function()
                print(#unloadBasket)
                if #unloadBasket > 0 then
                    ProgressBar("Unloading items...", 5000) -- Simulate unloading time
                    holdingObject = PutObjectInHands(PlayerPedId(), Config.ObjectPropList[unloadBasket[1].itemName]) -- Example prop, change as needed
                    
                    table.remove(unloadBasket, 1) -- Remove the first item from the basket
                else
                    Notify("Pawn Shop", "You have no items to unload.", "error")
                    return
                end
                
                
                
            end
        }
    })
    
    zoneID = exports.ox_target:addBoxZone({
        coords = config.dropOffItems, -- Change to your drop-off coordinates
        radius = 2.0,
        debug = true,
        options = {
            {
                label = 'Drop off Item',
                icon = 'fa-solid fa-check',
                onSelect = function()
                    if holdingObject then
                        ProgressBar("Dropping off item...", 5000) -- Simulate drop-off time
                        RemoveObjectFromHands(PlayerPedId(), holdingObject)
                        holdingObject = nil
                        Notify("Pawn Shop", "Item unloaded successfully.", "success")
                        if #unloadBasket == 0 then
                            
                            TravelBack(income, vehicle, dropOffVehicle, dropOffVehicleSpawn)
                            exports.ox_target:removeZone(zoneID)
                        end
                    else
                        Notify("Pawn Shop", "You must unload items before finishing the drop-off.", "error")
                    end
                end
            }
        }
    })
end

---ProgressBar 
---@param text string
---@param duration integer
function ProgressBar(text, duration)
    lib.progressBar({
        duration = duration or 5000,
        label = text,
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            mouse = false,
            combat = true
        },
        anim = {
            dict = "amb@world_human_vehicle_mechanic@male@base",
            clip = "base"
        },
        
    })
end

function onEnter()
    Isinside = true
    Notify("Pawn Shop", "Press E to Sell items", "error")
end
 
function onExit()
    Isinside = false
end

---Creates a sphere zone at coords
---@param coords vector3
---@return table zone
function CreateZone(coords)
    local zone = lib.zones.sphere({
        coords = coords,
        radius = 4.0,
        debug = true,
        onEnter = onEnter,
        onExit = onExit
    })
    return zone
end

---Check if the player is in the drop-off area and handle item selling
---@param config table Configuration for the drop-off
---@param income number Income from the sale
---@param vehicle number Vehicle entity used for drop-off
function DropOffCheckThread(config, income, vehicle, basket, dropOffVehicle, dropOffVehicleSpawn, blip)
    
    local zone = CreateZone(config.dropOff)

    Citizen.CreateThread(function()
        while currentJob do
            Citizen.Wait(0)
            if Isinside and IsControlJustReleased(0, 38) then -- E key
                Isinside = false
                zone:remove() -- Remove the zone when done
                SetBlipRoute(blip, false)
                RemoveBlip(blip)
                StartUnloading(config,income, vehicle, basket, dropOffVehicle, dropOffVehicleSpawn)
            end
        end
    end)

    

end

---@param SellLocationsConfig table Drop-off coordinates
---@param income number Income from the sale
function StartDropOff(SellLocationsConfig, income, basket,  dropOffVehicle, dropOffVehicleSpawn)

    for index, item in pairs(basket) do
        if not lib.callback.await('dn-pawnshop:basketItemCheck', false, item.itemName, item.count) then
            Notify("Pawn Shop", "You do not have enough of " .. item.itemName .. " in your pockets.", "error")
            return
        end
    end
    
    

    local config = SellLocationsConfig
    currentJob = true
    local vehicle = SpawnVehicle(dropOffVehicle, dropOffVehicleSpawn, dropOffVehicleSpawn.w)
    GiveKeys(vehicle)
    CreateBlipEntity(vehicle, 477, 0.6, 2, "Drop Off Vehicle")
    local dropOffBlip = CreateBlip(config.dropOff, 1, 0.7, 2, "Drop Off Location")
    Notify("Pawn Shop", "Go to the drop-off location to sell your items using the vehicle provided.", "info")

    DropOffCheckThread(SellLocationsConfig, income, vehicle, basket, dropOffVehicle, dropOffVehicleSpawn, dropOffBlip)
    
    
    
end
