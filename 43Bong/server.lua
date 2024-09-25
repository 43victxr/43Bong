ESX = exports["es_extended"]:getSharedObject()

RegisterServerEvent("eff_smokes")
AddEventHandler("eff_smokes", function(entity)
    TriggerClientEvent("c_eff_smokes", -1, entity)
end)

-- Evento para dar el bong al jugador
RegisterServerEvent("givearbong")
AddEventHandler("givearbong", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addInventoryItem('bong', 1)
end)

-- Registro del uso del item bong
ESX.RegisterUsableItem('bong', function(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    xPlayer.removeInventoryItem('bong', 1)
    TriggerClientEvent('bong:spawnear', playerId)
    print("Ejecutado")
end)

-- Corrección del comando spawn para pasar el playerId como argumento
RegisterCommand("spawn", function(source)
    if source == 0 then
        print("El comando no se puede ejecutar desde la consola del servidor.")
        return
    end

    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        TriggerClientEvent("bong:fumar", source)
    else
        print("El comando no se pudo ejecutar. El jugador no fue encontrado.")
    end
end, false)
