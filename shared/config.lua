Config = {}


Config.PricesUpdateTime = 30.0 -- Time in minutes to update the prices

--Inventory
Config.Inventory = 'ox_inventory' -- ox_inventory / qb-inventory / ps-inventory / qs-inventory / tgiann-inventory / codem-inventory
Config.InventoryImageFolder = "nui://ox_inventory/web/images/" -- Folder where the item images are stored

Config.PaymentAccount = 'cash' --cash : bank : black_money

Config.ObjectPropList = { -- Set custom props here for items otherwise it defaults to a box
    phone = "prop_phone_ing",
    tablet = "prop_cs_tablet",
    laptop = "prop_laptop_01a",
    television = "prop_tv_01",
}

--Seller Ped
Config.SellerPeds = {
    {
        model = "s_m_m_highsec_01",
        coords = vector3(-57.05, -196.64, 44.79),
        heading = 1,
        jobs = {"usedaton"},
        scenario = "WORLD_HUMAN_CLIPBOARD",
        dropOffVehicle = "mule", --Vehicle the player needs to drop off the items in
        dropOffVehicleSpawn = vector4(-66.97, -213.70, 45.45, 161), --Point where the vehicle spawns
    },
    
}


Config.SellLocations = {
    ["Docks"] = { --Label of the selling point
        dropOff = vector3(1187.56, -3252.29, 6.03), --Point player drops off the items#
        dropOffItems = vector3(1197.09, -3253.59, 7.10),
        description = "Takes Jewelry",
        buyerItems = { -- Table of items the selling location accepts
            gold_bar = {min = 500, max = 600},
            goldwatch = {min = 175, max = 200},
            diamond = {min = 350, max = 400},
            gold_ring = {min = 225, max = 250},
            ["10kgoldchain"] = {min = 700, max = 900},
            ruby = {min = 500, max = 2000},
            platinum_bar = {min = 4000, max = 5000},
            ruby_diamond = {min = 35000, max = 40000},
            
        }
    },
    ["Pier"] = { --Label of the selling point
        dropOff = vector3(-1809.79, -1197.33, 13.02), --Point player drops off the items#
        dropOffItems = vector3(-1803.44, -1198.17, 13.02),
        description = "Takes Electronic's",
        buyerItems = { -- Table of items the selling location accepts
            laptop = {min = 500, max = 700},
            tablet = {min = 400, max = 600},
            coffee_machine = {min = 500, max = 1500},
            painting = {min = 400, max = 600},
            computer = {min = 500, max = 1500},
            microwave = {min = 500, max = 1500},
            music_player = {min = 500, max = 1500},
            television = {min = 500, max = 1500},
            iphone = {min = 200, max = 350},
        }
    },
    ["Airport"] = { --Label of the selling point
        dropOff = vector3(-880.74, -2731.02, 13.83), --Point player drops off the items#
        dropOffItems = vector3(-872.52, -2735.48, 13.96),
        description = "Takes Car Parts",
        buyerItems = { -- Table of items the selling location accepts
            car_door = {min = 500, max = 700},
            car_wheel = {min = 400, max = 600},
            car_battery = {min = 500, max = 1500},
            car_gearbox = {min = 400, max = 600},
            car_radiator = {min = 500, max = 1500},
            car_scrap = {min = 500, max = 1500},
            car_hood = {min = 500, max = 1500},
            car_trunk = {min = 500, max = 1500},
            
        }
    },
    
    
}

