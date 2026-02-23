
function OpenPawnMenu(dropOffVehicle,dropOffVehicleSpawn)
    options = {}
    print(dropOffVehicle, dropOffVehicleSpawn)
    for i, k in pairs(Config.SellLocations) do
        --item = Config.SellLocations[i]
        
        options[#options + 1] = {
            title = i,
            -- icon = item.icon,
            description = k.description,
            
            onSelect = function()
                OpenLocationMenu(k.buyerItems, k, i, dropOffVehicle,dropOffVehicleSpawn)
            end
        }
    end

    

    options[#options + 1] = {
        title = 'Close',
        icon = 'xmark',
        onSelect = function()
            lib.hideContext()
        end
    }

    

    lib.registerContext({
        id = 'example_context_menu',
        title = 'Pawn Shop Menu',
        options = options
    })

    lib.showContext('example_context_menu')
end

function OpenBasketMenu(itemsTable, SellLocationsConfig, locationName, dropOffVehicle, dropOffVehicleSpawn)
    local options = {}
    --print("Opening basket menu for location: " .. locationName)
    local prices, oldsellprices = lib.callback.await('dn-pawnshop:getPrices', false)
    local totalValue = 0
    for itemIndex, itemData in pairs(basket) do
        
        if itemData.locationName ~= locationName then goto continue end
        if itemData and itemData.count > 0 then
            totalValue = totalValue + (prices[itemData.itemName] * itemData.count)
            options[#options + 1] = {
                title = itemData.itemName,
                icon = (Config.InventoryImageFolder .. '%s.png'):format(itemData.itemName),
                description = string.format('Count: %d Value: £%d', itemData.count, prices[itemData.itemName] * itemData.count),
                onSelect = function()
                    table.remove(basket, itemIndex)
                    Notify("Pawn Shop", "Removed from basket", "error")
                    OpenBasketMenu(itemsTable, SellLocationsConfig, locationName, dropOffVehicle, dropOffVehicleSpawn)
                end
            }
        end
        ::continue::
    end

    options[#options + 1] = {
        title = string.format('Sell Basket For: £%d', totalValue),
        icon = 'money-bill',
        onSelect = function()
            StartDropOff(SellLocationsConfig, totalValue, basket, dropOffVehicle, dropOffVehicleSpawn)
            basket = {} -- Clear the basket after selling
        end
    }

    options[#options + 1] = {
        title = 'Back',
        icon = 'xmark',
        onSelect = function()
            OpenLocationMenu(itemsTable, SellLocationsConfig, locationName, dropOffVehicle, dropOffVehicleSpawn)
        end
    }

    lib.registerContext({
        id = 'basket_context_menu',
        title = 'Basket Items',
        options = options
    })

    lib.showContext('basket_context_menu')
    
end

function OpenLocationMenu(itemsTable, SellLocationsConfig, locationName, dropOffVehicle, dropOffVehicleSpawn)
    local options = {}
    
    for itemName, priceRange in pairs(itemsTable) do
            local prices, oldsellprices = lib.callback.await('dn-pawnshop:getPrices', false)
            
            local change = math.floor(GetPercentageChange(oldsellprices[itemName] or 0, prices[itemName]))
            
            
            options[#options + 1] = {
            title = itemName,
            icon = (Config.InventoryImageFolder .. '%s.png'):format(itemName),
            description = string.format('Price: £%d Change: %d' , prices[itemName], change) .. "%",
            onSelect = function()
                if currentJob then
                    Notify("Pawn Shop", "You are already on a job.", "error")
                    return
                end
                local input = lib.inputDialog('Amount to sell', {
                    {type = 'number', label = 'Number input', description = 'Some number description', icon = 'hashtag', min = 1},
                })
                if not input then return end
                if not input[1] then return end
                if input[1] > 0 then
                    
                    for i, k in pairs(basket) do
                        if k.itemName == itemName and k.locationName == locationName then
                            k.count = k.count + input[1]
                            Notify("Pawn Shop", "Updated basket count: " .. k.count .. " " .. k.itemName .. "'s", "error")
                            OpenLocationMenu(itemsTable, SellLocationsConfig, locationName, dropOffVehicle, dropOffVehicleSpawn)
                            return
                        end
                    end
                    table.insert(basket, {locationName = locationName, itemName = itemName, count = input[1]})
                    Notify("Pawn Shop", "Added " .. input[1].. " " .. itemName .. "'s" ..  " to basket", "error")

                    OpenLocationMenu(itemsTable, SellLocationsConfig, locationName, dropOffVehicle, dropOffVehicleSpawn)
                else
                    Notify("Pawn Shop", "Invalid amount entered.", "error")
                end

                
                
            end
        }
        
        
    end
    
    options[#options + 1] = {
        title = 'Basket',
        icon = 'cart-shopping',
        onSelect = function()
            
            OpenBasketMenu(itemsTable, SellLocationsConfig, locationName, dropOffVehicle, dropOffVehicleSpawn)
        end
    }

    options[#options + 1] = {
        
        title = 'Back',
        icon = 'xmark',
        onSelect = function()
            OpenPawnMenu(dropOffVehicle, dropOffVehicleSpawn)
        end
        
    }

    lib.registerContext({
        id = 'location_context_menu',
        title = 'Sell Items',
        options = options
    })

    lib.showContext('location_context_menu')

end
