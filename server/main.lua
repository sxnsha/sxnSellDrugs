
local ESX = nil
if TriggerEvent then
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
end

if ESX == nil and exports and exports['es_extended'] then
    ESX = exports['es_extended']:getSharedObject()
end

-- Vérifie si le joueur a de la drogue

if ESX and ESX.RegisterServerCallback then
    ESX.RegisterServerCallback('disc-drugsales:hasDrugs', function(source, cb)
        local xPlayer = ESX.GetPlayerFromId and ESX.GetPlayerFromId(source) or (ESX.GetPlayerFromIdLegacy and ESX.GetPlayerFromIdLegacy(source))
        if not xPlayer then cb(false) return end
        local hasDrugs = false
        for k, v in pairs(Config.DrugItems) do
            local item = nil
            -- Compatibilité ox_inventory
            if exports.ox_inventory then
                item = exports.ox_inventory:GetItem(source, v.name, nil, true)
            else
                -- ESX classique
                item = xPlayer.getInventoryItem(v.name)
            end
            
            local count = 0
            if item then
                if type(item) == "number" then
                    count = item
                elseif item.count then
                    count = item.count
                elseif item.amount then
                    count = item.amount
                end
            end
            
            if count > 0 then
                hasDrugs = true
                print("Player has drug:", v.name, "count:", count) -- Debug
                break
            end
        end
        print("hasDrugs result:", hasDrugs) -- Debug
        cb(hasDrugs)
    end)

    ESX.RegisterServerCallback('disc-drugsales:getOnlinePolice', function(source, cb)
        local xPlayers = ESX.GetPlayers and ESX.GetPlayers() or (ESX.GetPlayersLegacy and ESX.GetPlayersLegacy())
        if not xPlayers then cb(0) return end
        local police = 0
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId and ESX.GetPlayerFromId(xPlayers[i]) or (ESX.GetPlayerFromIdLegacy and ESX.GetPlayerFromIdLegacy(xPlayers[i]))
            if xPlayer and (xPlayer.job and (xPlayer.job.name == 'police' or xPlayer.job.name == 'bcso')) then
                police = police + 1
            end
        end
        cb(police)
    end)

    ESX.RegisterServerCallback('disc-drugsales:sellDrug', function(source, cb)
        local xPlayer = ESX.GetPlayerFromId and ESX.GetPlayerFromId(source) or (ESX.GetPlayerFromIdLegacy and ESX.GetPlayerFromIdLegacy(source))
        if not xPlayer then cb(nil) return end
        local sold = nil
        for k, v in pairs(Config.DrugItems) do
            local item = nil
            local currentCount = 0
            
            -- Compatibilité ox_inventory
            if exports.ox_inventory then
                item = exports.ox_inventory:GetItem(source, v.name, nil, true)
                if type(item) == "number" then
                    currentCount = item
                elseif item and item.count then
                    currentCount = item.count
                elseif item and item.amount then
                    currentCount = item.amount
                end
            else
                -- ESX classique
                item = xPlayer.getInventoryItem(v.name)
                if item then
                    currentCount = item.count or 0
                end
            end
            
            if currentCount >= v.sellCountMin then
                local count = math.random(v.sellCountMin, v.sellCountMax)
                if currentCount < count then count = currentCount end
                if count > 0 then
                    -- Retirer les items
                    if exports.ox_inventory then
                        exports.ox_inventory:RemoveItem(source, v.name, count)
                    else
                        xPlayer.removeInventoryItem(v.name, count)
                    end
                    
                    local price = v.price * count
                    xPlayer.addAccountMoney('black_money', price)
                    sold = price
                    print("Sold", count, v.name, "for", price) -- Debug
                    break
                end
            end
        end
        cb(sold)
    end)
end

RegisterNetEvent("MLSPD:Serveur:AppelLSPD")
AddEventHandler("MLSPD:Serveur:AppelLSPD", function(type, message, coords)
    TriggerClientEvent('esx:showAdvancedNotification', -1, "LSPD", type or '', message or '', 'CHAR_CALL911', 1)
    -- Vous pouvez ajouter ici une logique pour notifier les policiers avec les coordonnées
end)

RegisterNetEvent("MBCSO:Serveur:Appel")
AddEventHandler("MBCSO:Serveur:Appel", function(type, message, coords)
    TriggerClientEvent('esx:showAdvancedNotification', -1, "BCSO", type or '', message or '', 'CHAR_CALL911', 1)
    -- Vous pouvez ajouter ici une logique pour notifier les policiers avec les coordonnées
end)
