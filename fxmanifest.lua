fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author '.Zenith'
description 'Çöp Karıştırma Scripti'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua'
}

client_scripts {
    'locales/*.lua',
    'config.lua',
    'client/*.lua'
}

server_scripts {
    'locales/*.lua',
    'config.lua',
    'server/*.lua'
}