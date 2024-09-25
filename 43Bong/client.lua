ESX = exports["es_extended"]:getSharedObject()

local animacionEnCurso = false

exports.ox_target:addModel('prop_bong_01', {
    {
        name = 'bong',
        event = 'bong:fumar',
        icon = 'fa-solid fa-cannabis',
        label = Config.Messages.smokeBong,
    }
})

exports.ox_target:addModel('prop_bong_01', {
    {
        name = 'bong2',
        event = 'bong:recoger',
        icon = 'fa-regular fa-hand',
        label = Config.Messages.removeBong,
    }
})

RegisterNetEvent("bong:spawnear")
AddEventHandler("bong:spawnear", function()
    print("Evento bong:spawnear recibido")
    local playerPed = PlayerPedId()
    local coords = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 0.8, 0.0)
    local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))

    local hit, coordZ = GetGroundZFor_3dCoord(coords.x, coords.y, z + 1.0)

    local modelHash = GetHashKey("prop_bong_01")
    RequestModel(modelHash)

    while not HasModelLoaded(modelHash) do
        Wait(500)
    end
    
    TriggerEvent('animacion2')
    Wait(1000)
    TriggerServerEvent("colocarbong")
    local prop = CreateObject(modelHash, coords.x, coords.y, coordZ, true, true)
    ESX.ShowNotification(Config.Messages.bongPlaced)
    SetEntityCollision(prop, true, true)
    FreezeEntityPosition(prop, true)
end)

RegisterCommand("cleareffect", function(source, args, rawCommand)
    ClearTimecycleModifier()
    ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent("bong:recoger")
AddEventHandler("bong:recoger", function()
    if not animacionEnCurso then
        local playerPed = PlayerId()
        local playerPos = GetEntityCoords(GetPlayerPed(-1))
        local bongObject = GetClosestObjectOfType(playerPos.x, playerPos.y, playerPos.z, 10.0, GetHashKey("prop_bong_01"), false, false, false)

        if DoesEntityExist(bongObject) then
            DeleteEntity(bongObject)
            TriggerServerEvent("givearbong")
            TriggerEvent('animacion2')
            Wait(1000)
            ESX.ShowNotification(Config.Messages.bongPickedUp)
        else
            ESX.ShowNotification(Config.Messages.noBongNearby)
        end
    else
        ESX.ShowNotification(Config.Messages.cannotPickUpWhileSmoking)
    end
end)

RegisterNetEvent("bong:fumar")
AddEventHandler("bong:fumar", function()
    local ped = PlayerPedId()
    local pedNetId = NetworkGetNetworkIdFromEntity(ped)
    if pedNetId ~= 0 then
        if not animacionEnCurso then
            animacionEnCurso = true
            TriggerEvent('animacion')
            Wait(8000)
            TriggerServerEvent("eff_smokes", pedNetId)
            Wait(4500)
            animacionEnCurso = false
        else
            ESX.ShowNotification(Config.Messages.alreadySmoking)
        end
    end
end)

RegisterNetEvent('animacion')
AddEventHandler('animacion', function()
    local player = PlayerPedId()
    local modelHash = GetHashKey("prop_bong_01")
    RequestAnimDict("anim@safehouse@bong")

    while not HasAnimDictLoaded("anim@safehouse@bong") do
        Wait(500)
    end

    ESX.ShowNotification(Config.Messages.startedSmoking)

    local boneIndex = GetPedBoneIndex(player, 18905)
    local x, y, z = 0.1, -0.26, 0.015
    local xRot, yRot, zRot = -90.0, 0.0, 0.0

    TaskPlayAnim(player, "anim@safehouse@bong", "bong_stage4", 8.0, -8.0, -1, 0, 0, false, false, false)
    FreezeEntityPosition(player, true)

    Wait(1000)
    local prop = CreateObject(modelHash, 0.0, 0.0, 0.0, true, false, false)
    AttachEntityToEntity(prop, player, boneIndex, x, y, z, xRot, yRot, zRot, true, true, false, true, 1, true)

    Wait(11800)
    DeleteEntity(prop)
    Wait(3200)

    ClearPedTasks(player)
    ESX.ShowNotification(Config.Messages.stoppedSmoking)
    FreezeEntityPosition(player, false)
    RemoveAnimDict("anim@safehouse@bong")
    SetTimecycleModifier("spectator5")
    Wait(50000)
    ClearTimecycleModifier()
    ClearPedTasks(player)
end)

p_smoke_location = {
    20279,
}
p_smoke_particle = "exp_grd_bzgas_smoke"
p_smoke_particle_asset = "core"

RegisterNetEvent("c_eff_smokes")
AddEventHandler("c_eff_smokes", function(c_ped)
    for _, bones in pairs(p_smoke_location) do
        if DoesEntityExist(NetToPed(c_ped)) and not IsEntityDead(NetToPed(c_ped)) then
            local createdSmoke = UseParticleFxAssetNextCall(p_smoke_particle_asset)
            local createdPart = StartParticleFxLoopedOnEntityBone(p_smoke_particle, NetToPed(c_ped), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetPedBoneIndex(NetToPed(c_ped), bones), 1.0, 0.0, 0.0, 0.0, true, true, true, 2.0)

            Wait(3000)

            while DoesParticleFxLoopedExist(createdSmoke) do
                StopParticleFxLooped(createdSmoke, 1)
                Wait(0)
            end

            while DoesParticleFxLoopedExist(createdPart) do
                StopParticleFxLooped(createdPart, 1)
                Wait(0)
            end

            while DoesParticleFxLoopedExist(p_smoke_particle) do
                StopParticleFxLooped(p_smoke_particle, 1)
                Wait(0)
            end

            while DoesParticleFxLoopedExist(p_smoke_particle_asset) do
                StopParticleFxLooped(p_smoke_particle_asset, 1)
                Wait(0)
            end

            Wait(3000 * 3)
            RemoveParticleFxFromEntity(NetToPed(c_ped))
            break
        end
    end
end)

RegisterNetEvent('animacion2')
AddEventHandler('animacion2', function()
    local player = PlayerPedId()
    RequestAnimDict("random@domestic")

    while not HasAnimDictLoaded("random@domestic") do
        Wait(500)
    end

    TaskPlayAnim(player, "random@domestic", "pickup_low", 8.0, -8.0, -1, 0, 0, false, false, false)
end)
