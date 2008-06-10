-- Project Settings
project.name     = "Lua"
project.bindir   = "bin"
project.libdir   = "lib"

-- Configurations options
project.configs = { "Release", "DllRelease", "Debug", "DllDebug" }

-- Project Packages
dopackage( "src/lualib" )
dopackage( "src/luaexe" )
dopackage( "src/luacompiler" )

