local spawnedVehicles = {} -- Tabla para almacenar los vehículos generados

function spawnVehicleIfNotExists(model, coords, spawnTime)
    if not spawnTime then
        print("Error: spawnTime es nil para el modelo " .. model)
        return
    end

    local alreadySpawned = false

    -- Verificar si ya hay un vehículo en las coordenadas dadas
    for _, vehicleData in ipairs(spawnedVehicles) do
        if #(coords - vehicleData.coords) < 5.0 then -- Chequear si la distancia es menor a 5 metros
            if DoesEntityExist(vehicleData.vehicle) then
                alreadySpawned = true
                break
            else
                -- Eliminar el vehículo de la lista si ya no existe
                table.remove(spawnedVehicles, _)
            end
        end
    end

    -- Si no hay un vehículo en esas coordenadas, spawnear uno
    if not alreadySpawned then
        local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, coords.w, true, false)
        SetVehicleDoorsLocked(vehicle, 2) -- Bloquear el vehículo
        table.insert(spawnedVehicles, {vehicle = vehicle, coords = coords})

        print("Vehículo generado en las coordenadas: " .. coords.x .. ", " .. coords.y .. ", " .. coords.z)

        -- Esperar un tiempo y chequear si el vehículo sigue existiendo, si no, volver a spawnear
        Citizen.CreateThread(function()
            Citizen.Wait(spawnTime * 1000) -- Tiempo en segundos hasta que el vehículo pueda reaparecer

            -- Verificar si el vehículo sigue existiendo en el mundo
            if not DoesEntityExist(vehicle) then
                print("Vehículo desaparecido, generando nuevamente...")
                spawnVehicleIfNotExists(model, coords, spawnTime)
            end
        end)
    else
        print("Ya hay un vehículo en las coordenadas: " .. coords.x .. ", " .. coords.y .. ", " .. coords.z)
    end
end

-- Spawnear vehículos en intervalos
Citizen.CreateThread(function()
    for _, spawn in ipairs(Config.VehicleSpawns) do
        if spawn.model and spawn.coords and spawn.spawnTime then
            spawnVehicleIfNotExists(spawn.model, spawn.coords, spawn.spawnTime)
        else
            print("Error: Datos faltantes en la configuración de vehículos")
        end
        Citizen.Wait(1000) -- Esperar un segundo entre spawns para evitar sobrecarga
    end
end)
