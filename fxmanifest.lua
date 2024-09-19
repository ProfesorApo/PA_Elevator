fx_version 'cerulean'
author 'Profesor Apo'
description 'Script ascenseur'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'


shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'locales/*.lua'
}

client_scripts {
    'client.lua'
}

dependencies {
    'ox_lib' 
}
