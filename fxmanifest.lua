fx_version 'cerulean'
game 'gta5'

author 'X-CODE (sokey)'
description 'Police Radar'
version '1.0.0'

shared_scripts {
    '@es_extended/locale.lua',
    'lua/locales/*.lua',
    'lua/shared/*.lua'
}

client_scripts {
    'lua/client/*.lua'
}

dependency 'es_extended'

ui_page 'html/index.html'

files {
    'html/**',
    'html/*',
    'html/css/*',
    'html/js/*',
}
