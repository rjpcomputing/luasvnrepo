----------------------------------------------------------------------------
--	Name:		premake4.lua, a Premake4 script
--	Author:		Ben Cleveland, based on premake.lua by Ryan Pusztai.
--	Date:		11/24/2010
--	Version:	1.00
--
--	Notes:
-- ----------------------------------------------------------------------------

-- Project Settings
solution		"Lua"
targetdir		"bin"
implibdir		"lib"
configurations { "Debug", "Release" }


-- Project Packages
dofile( "lualib4.lua" )
dofile( "luaexe4.lua" )
dofile( "luacompiler4.lua" )

-- OPTIONS
newoption {
   trigger     = "dynamic-runtime",
   description = "Use the dynamically loadable version of the runtime."
}
