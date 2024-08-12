-- Aplicar configuraciones de densidades
Citizen.CreateThread(function()
	while true do
	    Citizen.Wait(0)
	    
	    -- Ajustes de densidad
		SetVehicleDensityMultiplierThisFrame(Config.DensitySettings.VehicleDensityMultiplier)
		SetRandomVehicleDensityMultiplierThisFrame(Config.DensitySettings.VehicleDensityMultiplier)
		SetParkedVehicleDensityMultiplierThisFrame(Config.DensitySettings.ParkedVehicleDensityMultiplier)
		SetPedDensityMultiplierThisFrame(Config.DensitySettings.PedDensityMultiplier)
		SetScenarioPedDensityMultiplierThisFrame(Config.DensitySettings.ScenarioPedDensityMultiplier, Config.DensitySettings.ScenarioPedDensityMultiplier)
		
		-- Desactivar policías si está configurado
		if Config.DisableCops then
			SetCreateRandomCops(false)
			SetCreateRandomCopsNotOnScenarios(false)
			SetCreateRandomCopsOnScenarios(false)
			SetMaxWantedLevel(0)
		else
			SetMaxWantedLevel(5)
		end

		-- Desactivar camiones de basura y barcos aleatorios si la densidad de vehículos es 0
		if Config.DensitySettings.VehicleDensityMultiplier == 0 then
			SetGarbageTrucks(false)
			SetRandomBoats(false)
		end
		
		-- Limpieza de vehículos si la densidad de vehículos y aparcados es 0
		if Config.DensitySettings.VehicleDensityMultiplier == 0 and Config.DensitySettings.ParkedVehicleDensityMultiplier == 0 then
			local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
			ClearAreaOfVehicles(x, y, z, 1000, false, false, false, false, false)
			RemoveVehiclesFromGeneratorsInArea(x - 500.0, y - 500.0, z - 500.0, x + 500.0, y + 500.0, z + 500.0)
		end
	end
end)

RegisterNetEvent('updateDispatchServices')
AddEventHandler('updateDispatchServices', function(data)
	Config.DisabledDispatchServices = data.DisabledDispatchServices
	for service, enabled in pairs(Config.DisabledDispatchServices) do
		EnableDispatchService(service, enabled)
	end
end)


-- Deshabilitar servicios de despachos
Citizen.CreateThread(function()
    for service, enabled in pairs(Config.DisabledDispatchServices) do
        if enabled then
            local serviceIndex = GetHashKey(service)
            -- Usar pcall para intentar deshabilitar el servicio de despacho
            local success, err = pcall(function()
                DisableDispatchService(serviceIndex, true)
            end)
            if not success then
                print("Error al deshabilitar el servicio de despacho: ", err)
            end
        end
    end
end)

-- Deshabilitar policías persiguiendo al jugador si está configurado
if Config.DisableCops then
    Citizen.CreateThread(function()
        while true do
            local playerPed = PlayerPedId()
            SetPoliceIgnorePlayer(playerPed, true)
            SetDispatchCopsForPlayer(playerPed, false)
            Wait(1000)
        end
    end)
end
