ESX = exports["es_extended"]:getSharedObject()

RegisterServerEvent("eff_smokes")
AddEventHandler("eff_smokes", function(entity)
    TriggerClientEvent("c_eff_smokes", -1, entity)
end)

-- RECOGER BONG
RegisterServerEvent("givearbong")
AddEventHandler("givearbong", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addInventoryItem('bong', 1)
end)

ESX.RegisterUsableItem('bong', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    xPlayer.removeInventoryItem('bong', 1)
    
    TriggerClientEvent('bong:spawnear', source)
end)

RegisterServerEvent("givearbong2")
AddEventHandler("givearbong2", function(amount)
    
    local xPlayer = ESX.GetPlayerFromId(source)
    
    moneyf = amount * Config.bongPrice
    
    pmoney = xPlayer.hasItem(Config.moneyItem)
    
    if pmoney.count >= moneyf then
        xPlayer.removeInventoryItem(Config.moneyItem, moneyf)
        xPlayer.addInventoryItem('bong', amount)
        TriggerClientEvent('esx:showNotification', source, 'You have succesfully bought '.. amount .. ' bong for ' .. moneyf .. '$', 'success')
    else
        TriggerClientEvent('esx:showNotification', source, 'You dont have enought money!', 'error')
        
    end
    
end)