-- ----------------------------------------------------------------------------
--	Premake script for the wxLua project.
--	Author:		RJP Computing <rjpcomputing@gmail.com>
--	Date:		03/23/2009
--	Version:	2.00-beta
--
--	Notes:
-- ----------------------------------------------------------------------------

-- INCLUDES -------------------------------------------------------------------
--
dofile( "build/presets.lua" )
dofile( "build/wxpresets.lua")

-- OPTIONS --------------------------------------------------------------------
--
addoption( "dynamic-runtime", "Use the dynamicly loadable version of the runtime." )
addoption( "wxluafreeze", "Build wxLuaFreeze instead of the Lua module." )

-- PROJECT SETTINGS -----------------------------------------------------------
--
project.name	= "wxLua"
project.bindir	= "../../bin"
project.libdir	= "lib"

-- CONFIGURATIONS -------------------------------------------------------------
--
--project.configs	= { "DllRelease", "DllDebug", "Release", "Debug" }

-- PACKAGES -------------------------------------------------------------------
--
if options["wxluafreeze"] then
	dopackage( "wxlua" )
	dopackage( "wxluafreeze" )
else
	dopackage( "wxlua_module" )
end
dopackage( "lualib" )

