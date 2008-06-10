-- Project Settings
project.name     = "toLua++"
project.bindir   = "bin"
project.libdir   = "lib"

-- Configureations. All I am doing is reordering them so that
-- it defaults to a Release build.
project.configs = { "Release", "Debug" }

-- Project Packages
dopackage( "src/bin/tolua++exe" )
dopackage( "src/lib/tolua++lib" )
dopackage( "../lua/lualib" )				-- This path might need to change.

-- Add options here.
addoption( "dynamic-runtime", "Use the dynamicly loadable version of the runtime." )
