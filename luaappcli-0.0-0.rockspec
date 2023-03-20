package = "luaappcli"
version = "0.0-0"
source = {
	url = "git@github.com:infologicmgmt/luaappcli.git"
}
description = {
	summary = "Sample skeleton cli program",
	detailed = [[
		Sample skeleton cli program
	]],
	homepage = "http://github.com:infologicmgmt/luaappcli",
	license = "MIT"
}
dependencies = {
	"lua >= 5.1",
	"alt-getopt",
	"lyaml",
	"inspect"
}
source = {
       url = "http://github.com:infologicmgmt/luaappcli",
       dir ="src"
}

build = {
	type = "builtin",
	modules = {
		luappcli = "src/luaappcli.lua"
	}
}