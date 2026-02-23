SellPrices = {}
OldSellPrices = {}

function UpdatePrices()
    table.clone(SellPrices, OldSellPrices)
    for i, k in pairs(Config.SellLocations) do
        for j, x in pairs(k.buyerItems) do
            local item = x
            SellPrices[j] = math.random(item.min, item.max)
        end 
    end
end


CreateThread(function()
    while true do
        UpdatePrices()
        Wait(Config.PricesUpdateTime * 60 * 1000) 
    end
end)

lib.callback.register('dn-pawnshop:getPrices', function(source)
    return SellPrices, OldSellPrices
end)