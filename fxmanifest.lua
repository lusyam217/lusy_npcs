fx_version 'cerulean'
game 'gta5'

author 'lusyam_217'
description 'Control de NPCs y vehículos con configuraciones personalizadas'
version '1.0.0'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client/main.lua',
    'client/cl_vehicles.lua'
}

server_scripts {
    'server/sv_vehicles.lua'
}
