local ESX = exports['es_extended']:getSharedObject()
local ox_target = exports.ox_target
local inMinigame = false

-- Función para dibujar un círculo en pantalla
function drawCircle(x, y, radius, segments, r, g, b, a)
    local step = 360 / segments
    for i = 0, 360, step do
        local _x = radius * math.cos(math.rad(i)) + x
        local _y = radius * math.sin(math.rad(i)) + y
        local next_x = radius * math.cos(math.rad(i + step)) + x
        local next_y = radius * math.sin(math.rad(i + step)) + y
        DrawLine(_x, _y, 0.0, next_x, next_y, 0.0, r, g, b, a)
    end
end

-- Función para iniciar el minijuego circular
function startMinigame()
    inMinigame = true
    local success = false
    local radius = 0.15
    local segments = 100
    local targetAngle = math.random(0, 360)
    local angle = 0
    local speed = 2.0
    local targetHit = false

    while inMinigame do
        Citizen.Wait(0)

        -- Dibujar el círculo
        drawCircle(0.5, 0.5, radius, segments, 255, 255, 255, 150)

        -- Dibujar la barra de progreso giratoria
        local x = 0.5 + radius * math.cos(math.rad(angle))
        local y = 0.5 + radius * math.sin(math.rad(angle))
        DrawMarker(28, x, y, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.03, 0.03, 0.03, 0, 255, 0, 150, false, true, 2, false, nil, nil, false)

        -- Actualizar el ángulo
        angle = angle + speed
        if angle >= 360 then
            angle = 0
        end

        -- Capturar la entrada del usuario
        if IsControlJustPressed(0, 51) then -- E key
            local distance = math.abs(angle - targetAngle)
            if distance < 15 or distance > 345 then -- Acierto si el ángulo está cerca del target
                success = true
                targetHit = true
                ESX.ShowNotification("¡Minijuego completado con éxito!")
                inMinigame = false
            else
                ESX.ShowNotification("Fallaste el minijuego.")
                inMinigame = false
            end
        end
    end

    return success
end

-- Evento para iniciar el minijuego de desbloqueo de vehículos
RegisterNetEvent('startVehicleMinigame')
AddEventHandler('startVehicleMinigame', function(vehicle)
    local result = startMinigame()
    if result then
        SetVehicleDoorsLocked(vehicle, 1) -- Desbloquear el vehículo
        ESX.ShowNotification("Vehículo desbloqueado!")
    else
        ESX.ShowNotification("No se pudo desbloquear el vehículo.")
    end
end)

-- Configuración de ox_target para iniciar el minijuego al interactuar con un vehículo
ox_target:addGlobalVehicle({
    {
        label = 'Abrir Vehículo',
        items = Config.LockpickItem,
        onSelect = function(data)
            local vehicle = data.entity
            TriggerEvent('startVehicleMinigame', vehicle)
        end
    }
})
