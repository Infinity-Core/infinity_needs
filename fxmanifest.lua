game 		 'rdr3'
fx_version 	 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
author 	     'ALTITUDE-DEV.COM'
description  'INFINITY CORE FRAMEWORK NEEDS/INVENTORY/META SYSTEM FULLY SYNC WITH CORE'
version 	 '1.0.0'
infinitycore_dev 	    'Shepard & iireddev'


ui_page "inventory/inventory.html"

files {
    'inventory/inventory.html',
	'inventory/items/*.png',
	'inventory/items/*.jpg',
	'inventory/items/*.webp',
	'inventory/design/*.png',
	'inventory/design/*.jpg',
	'inventory/design/*.webp',
	'inventory/design/*.wav',
    'inventory/*.js',
    'inventory/*.css',
	'inventory/vendor/*.css',
	'inventory/*.json'
}

client_scripts {
	'config.lua',
	'module_client/cl_gunsystem.lua',
	'module_client/cl_foods.lua',
	'module_client/cl_inventory.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'config.lua',
	'module_server/sv_payday.lua',
	'module_server/sv_inventory.lua'
}

exports {
	'Eat_Metabolism',
	'Water_Metabolism',
	'Health_Metabolism',
	'Sleep_Metabolism',
	'CheckPlayerInventory',
	'RemoveInventoryItem',
	'Temp_Metabolism',
	'JSON_CHECKER',
	'JsonItemsList',
	'OpenInventory'
}

server_exports {
	'AddInventoryItem',
	'RemoveInventoryItem',
	'UseInventoryItem',
	'CheckPlayerInventory',
	'JSON_CHECKER',
	'JsonItemsList'
}