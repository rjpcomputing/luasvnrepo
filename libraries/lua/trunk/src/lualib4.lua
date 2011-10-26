----------------------------------------------------------------------------
--	Name:		lualib4.lua, a Premake4 script
--	Author:		Ben Cleveland, based on lualib.lua by Ryan Pusztai
--	Date:		11/24/2010
--	Version:	1.00
--
--	Notes:
-- ----------------------------------------------------------------------------

-- OPTIONS -------------------------------------------------------------------
--
newoption
{
	trigger = "lua-shared",
	description = "Create a dynamicly loadable version (dll/so) of lua."
}
newoption
{
	trigger = "lua-cpp",
	description = "Compile Lua library as C++ code."
}


-- GENERAL SETUP -------------------------------------------------------------
--
project		"LuaLib"
uuid		"E0E342D0-1638-6F40-A4AF-A16DE1D52989"
targetname 	"lua5.1"

if ( _OPTIONS["lua-cpp"] ) then
	language	"c++"
else
	language	"c"
end

if ( _OPTIONS["lua-shared"] ) then
	kind	"SharedLib"
	targetdir  	( solution().basedir .. "/bin" )
else
	kind	"StaticLib"
	targetdir  	( solution().basedir .. "/lib" )
end

files 		{ "*.c", "*.h", "*.lua" }
excludes 	{ "lua.c", "luac.c" }

-- COMPILER SPECIFIC SETUP ----------------------------------------------------
--
function ActionUsesGCC()
	return ("gmake" == _ACTION or "codelite" == _ACTION or "codeblocks" == _ACTION or "xcode3" == _ACTION)
end

if ActionUsesGCC() then
	flags { "NoImportLib", "extrawarnings" }
	buildoptions { "-W" }
	-- Set the objects directories.
	objdir ".obj"
end

if ( ( _ACTION == "vs2005" ) or ( _ACTION == "vs2008" ) or ( _ACTION == "vs2010" ) ) then
	-- Windows and Visual C++ 2005/2008/2010
	defines { "_CRT_SECURE_NO_DEPRECATE" }
end

-- OPERATING SYSTEM SPECIFIC SETTINGS -----------------------------------------
--
if ( os.get() == "windows" ) then											-- WINDOWS
	defines { "_WIN32", "WIN32", "_WINDOWS" }
	if ( _OPTIONS["lua-shared"] ) then
		defines { "LUA_BUILD_AS_DLL" }
	end
	if ActionUsesGCC() then
		buildoptions { "-mthreads" }
		linkoptions { "-mthreads" }
	end
elseif ( os.get() == "linux" ) then										-- LINUX
	defines { "LUA_USE_LINUX" }
	--table.insert( package.links, { "dl", "m", "readline", "history", "ncurses" } )
	if ( _OPTIONS["lua-shared"] ) then
		linkoptions { "-fPIC" }
		defines { "PIC" }
	end
	--table.insert( package.linkoptions, { "-Wl,-E" } )
else																-- MACOSX
	defines { "LUA_USE_MACOSX" }
end


-- COMPILER SETTINGS ----------------------------------------------------------
--
-- Build Flags
if ( _OPTIONS["lua-shared"] ) then
	if ActionUsesGCC() then
		flags { "noimportlib" }
	end
end

-- CONFIGURATION SPECIFIC SETTINGS --------------------------------------------
--
if ( _OPTIONS["dynamic-runtime"] ) then
	configuration { "Debug" }
		flags	{ "Symbols" }
	configuration { "Release" }
		flags { "optimize" }
else
	configuration { "Debug" }
		flags	{ "StaticRuntime", "Symbols" }
	configuration { "Release" }
		flags	{ "StaticRuntime", "Optimize" }
end


configuration { "Debug" }
	targetsuffix "d"
	defines	{ "DEBUG", "_DEBUG" }

configuration { "Release" }
	defines	{ "NDEBUG" }

configuration( "vs2008 or vs2010" )
	-- multi-process building
	flags( "NoMinimalRebuild" )
	buildoptions( "/MP" )

configuration {}
