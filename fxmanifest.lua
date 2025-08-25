fx_version "adamant"
games {"rdr3"}
rdr3_warning "I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships."

client_scripts {
    "exports.js",
    "_cfg.lua",
    "client.lua"
}

server_scripts {
	'server.lua'
}

shared_scripts {
	'@frp_lib/library/linker.lua',
	'g_config.lua'
}

exports {
    "NativeCreateComposite",
    "NativeGetCompositeEntities"
}