fx_version "cerulean"
game "gta5"
lua54 "yes"

description "A Pawn Shop Script by District Network Studios"
version 'v1.0.0'
author "DJultra14"

dependencies {
    'ox_target',
    'ox_lib'
}

shared_scripts {
    "shared/*.lua",
    '@ox_lib/init.lua',
}

client_scripts {
    "client/*.lua",
    'inventory/client/*.lua',
}

server_scripts {
    "server/*.lua",
    '@qbx_core/modules/lib.lua',
    'inventory/server/*.lua',
}



files {
 
}

escrow_ignore {
    "*/*.*",
}
  

