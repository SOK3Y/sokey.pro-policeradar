local radar = {
    pauseToggled = false,
    shown = false,
    freeze = false,
    info = {
        plate = 'ŁADOWANIE',
        speed = 0
    },
    info2 = {
        plate = 'ŁADOWANIE',
        speed = 0
    }
}

Citizen.CreateThread(function()
    RegisterKeyMapping('toggleRadar', _U('toggle_radar'), 'keyboard', Config.Keys['Toggle'])
    RegisterKeyMapping('freezeRadar', _U('freeze_radar'), 'keyboard', Config.Keys['Freeze'])
    RegisterCommand('toggleRadar', function()
        toggleRadar()    
    end)
    RegisterCommand('freezeRadar', function()
        freezeRadar()
    end)
end)

Citizen.CreateThread(function()
    while true do
        Wait(50)
        if not radar.shown and not IsPauseMenuActive() and radar.pauseToggled then
            toggleRadar()
            radar.pauseToggled = false
        end
        if radar.shown then
            if IsPauseMenuActive() then
                toggleRadar()
                radar.pauseToggled = true
            end
            if not IsPedInAnyPoliceVehicle(PlayerPedId()) then
                toggleRadar()
            end
            if not radar.freeze then
                local veh = GetVehiclePedIsIn(PlayerPedId(), false)
                local coordA = GetOffsetFromEntityInWorldCoords(veh, 0.0, 1.0, 1.0)
                local coordB = GetOffsetFromEntityInWorldCoords(veh, 0.0, 105.0, 0.0)
                local frontcar = StartShapeTestCapsule(coordA, coordB, 3.0, 10, veh, 7)
                local a, b, c, d, e = GetShapeTestResult(frontcar)
                if IsEntityAVehicle(e) then
                    radar.info = {
                        plate = GetVehicleNumberPlateText(e),
                        speed =  math.ceil(GetEntitySpeed(e)*2.236936),
                        model = GetDisplayNameFromVehicleModel(GetEntityModel(e))
                    }
                end
                local bcoordB = GetOffsetFromEntityInWorldCoords(veh, 0.0, -105.0, 0.0)
                local rearcar = StartShapeTestCapsule(coordA, bcoordB, 3.0, 10, veh, 7)
                local f, g, h, i, j = GetShapeTestResult(rearcar)
                if IsEntityAVehicle(j) then
                    radar.info2 = {
                        plate = GetVehicleNumberPlateText(j),
                        speed = math.ceil(GetEntitySpeed(j)*2.236936),
                        model = GetDisplayNameFromVehicleModel(GetEntityModel(j))
                    }
                end
                updateRadar()
            else
                Citizen.Wait(800)
            end
        else
            Citizen.Wait(800)
        end
    end
end)

function updateRadar()
    SendNUIMessage({
        type = "update",
        frontPlate = radar.info.plate,
        backPlate = radar.info2.plate,
        frontSpeed = radar.info.speed,
        backSpeed = radar.info2.speed
    })
end

function toggleRadar()
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)
        local name = string.lower(GetDisplayNameFromVehicleModel(GetEntityModel(veh)))

        local vehiclesList = Config.VehicleList

        if radar.shown then
            SendNUIMessage({
                type = "toggle",
                status = not radar.shown
            })
            radar.shown = not radar.shown
        else
            local found = false
            for k,v in pairs(vehiclesList) do
                if(name:find(string.lower(v))) then
                    found = true
                end
            end
            if found then
                SendNUIMessage({
                    type = "toggle",
                    status = not radar.shown
                })
                radar.shown = not radar.shown
            end
        end
    end
end

function freezeRadar()
    radar.freeze = not radar.freeze
end