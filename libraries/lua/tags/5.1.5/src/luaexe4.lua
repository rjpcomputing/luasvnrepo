----------------------------------------------------------------------------
--	Name:		luaexe4.lua, a Premake4 script
--	Author:		Ben Cleveland, based on luaexe.lua by Ryan Pusztai
--	Date:		11/24/2010
--	Version:	1.00
--
--	Notes:
-- ----------------------------------------------------------------------------

-- GENERAL SETUP -------------------------------------------------------------
--
project		"Lua"
language	"c"
kind		"ConsoleApp"
targetname	"lua"

-- Files
files		{ "lua.c", "*.h" }
excludes	{ "luac.c" }

-- Include paths
-- all files are included in one directory
--includedirs	{ "include" }

-- LINKER SETTINGS ------------------------------------------------------------
--
-- Libraries to link against.
links	{ "LuaLib" }

-- Linker directory paths.
-- all files are included in one directory
--libdirs	{ "lua" }

-- COMPILER SPECIFIC SETUP ----------------------------------------------------
--
function ActionUsesGCC()
	return ("gmake" == _ACTION or "codelite" == _ACTION or "codeblocks" == _ACTION or "xcode3" == _ACTION)
end

if ActionUsesGCC() then
	flags "extrawarnings"
	buildoptions { "-W" }
	-- Set the objects directories.
	objdir	".obj"
end

if ( ( _ACTION == "vs2005" ) or ( _ACTION == "vs2008" ) or ( _ACTION == "vs2010" ) ) then
	-- Windows and Visual C++ 2005/2008/2010
	defines "_CRT_SECURE_NO_DEPRECATE"
end

-- OPERATING SYSTEM SPECIFIC SETTINGS -----------------------------------------
--
if ( os.get() == "windows" ) then											-- WINDOWS
	files { "lua.rc" }
	defines { "_WIN32", "WIN32", "_WINDOWS" }
	--if ( _OPTIONS["lua-shared"] ) then
		--defines { "LUA_BUILD_AS_DLL" }
	--end
	if ActionUsesGCC() then
		buildoptions { "-mthreads" }
		linkoptions { "-mthreads" }
	end
elseif ( os.get() == "linux" ) then										-- LINUX
	defines { "LUA_USE_LINUX" }
	links { "dl", "m", "readline", "history", "ncurses" }
	linkoptions { "-Wl,-E" }
else																-- MACOSX
	defines { "LUA_USE_MACOSX" }
end

-- CONFIGURATION SPECIFIC SETTINGS --------------------------------------------
--
if ( _OPTIONS["dynamic-runtime"] ) then
	configuartion "Release"
		flags { "no-symbols", "optimize" }
else
	configuration "Debug"
		flags	{ "StaticRuntime", "symbols" }
	configuration "Release"
		flags	{ "StaticRuntime",  "optimize" }
end


configuration "Debug"
	defines	{ "DEBUG", "_DEBUG" }
	targetsuffix "d"

configuration "Release"
	defines	{ "NDEBUG" }

configuration( "vs2008 or vs2010" )
	-- multi-process building
	flags( "NoMinimalRebuild" )
	buildoptions( "/MP" )
