-- Project Settings
project.name     = "ex"
project.bindir   = "bin"
project.libdir   = "lib"

-- Project Packages
dopackage( "ex" )
dopackage( "../lua/LuaLib" )

-- Add options here.
addoption( "dynamic-runtime", "Use the dynamicly loadable version of the runtime." )
