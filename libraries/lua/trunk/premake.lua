-- Project Settings
project.name     = "Lua"
project.bindir   = "bin"
project.libdir   = "lib"

-- Configurations options
project.configs = { "Release", "Debug" }

-- Project Packages
dopackage( "src/lualib" )
dopackage( "src/luaexe" )
dopackage( "src/luacompiler" )

