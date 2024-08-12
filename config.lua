Config = {}

-- Configuración de densidades
Config.DensitySettings = {
    VehicleDensityMultiplier = 0.001, -- Densidad del tráfico
    ParkedVehicleDensityMultiplier = 0.3, -- Densidad de vehículos estacionados
    PedDensityMultiplier = 0.5, -- Densidad de peatones
    ScenarioPedDensityMultiplier = 0.5 -- Densidad de escenarios de peatones
}

-- Desactivar o activar policías
Config.DisableCops = true

-- Servicios de despacho deshabilitados
Config.DisabledDispatchServices = {
    [1] = false, -- Disables Police Automobiles
    [2] = false, -- Disables Police Helicopters
    [3] = false, -- Disables Ambulance/Paramedics
    [4] = false, -- Disables Fire Dept.
    [5] = false, -- Disables Gangs
    [6] = false, -- Disables Police Boats
    [7] = false, -- Disables Army
    [8] = false  -- Disables SWAT
}


-- Deshabilitar policías persiguiendo al jugador
Config.DisableCops = true

-- Spawneo de vehículos en coordenadas específicas
Config.VehicleSpawns = {
    {model = "adder", coords = vector4(-356.5755, -753.7805, 33.9685, 92.1684), spawnTime = 600}, -- 10 minutos de respawn
    -- Puedes duplicar esta tabla para añadir más vehículos
}

-- Configuración para robar vehículos
Config.LockpickItem = "lockpick"
