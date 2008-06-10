-- GENERAL SETUP -------------------------------------------------------------
--
package.name								= "LuaCompiler"
package.language							= "c"
package.kind								= "exe"
package.target								= "luac"
package.config["Debug"].target				= package.target .. "d"

-- COMPILER SETTINGS ----------------------------------------------------------
--
-- Build Flags
if ( options["dynamic-runtime"] ) then
	package.config["Release"].buildflags	= { "no-symbols", "optimize" }
else
	package.config["Debug"].buildflags		= { "static-runtime" }
	package.config["Release"].buildflags	= { "static-runtime", "no-symbols", "optimize" }
end

-- Defined Symbols
package.config["Debug"].defines				= { "DEBUG", "_DEBUG" }
package.config["Release"].defines			= { "NDEBUG" }

-- Files
package.files								= { matchfiles( "*.c", "*.h" ) }
package.excludes							= { "lua.c" }

-- Include paths
-- all files are included in one directory
--package.includepaths						= { "include" }

-- LINKER SETTINGS ------------------------------------------------------------
--
-- Libraries to link against.
package.links								= { "LuaLib" }

-- Linker directory paths.
-- all files are included in one directory
--package.libpaths							= { "lua" }

-- COMPILER SPECIFIC SETUP ----------------------------------------------------
--
if ( ( target == "gnu" ) or ( target == "cb-gcc" ) ) then
	table.insert( package.buildflags, "extra-warnings" )
	table.insert( package.buildoptions, { "-W" } )
	-- Set the objects directories.
	package.objdir							= ".obj"
end

if ( ( target == "vs2005" ) or ( target == "vs2008" ) ) then
	-- Windows and Visual C++ 2005/2008
	table.insert( package.defines, "_CRT_SECURE_NO_DEPRECATE" )
end

-- OPERATING SYSTEM SPECIFIC SETTINGS -----------------------------------------
--
if ( OS == "windows" ) then											-- WINDOWS
	table.insert( package.defines, { "_WIN32", "WIN32", "_WINDOWS" } )
	--if ( options["lua-shared"] ) then
		--table.insert( package.defines, { "LUA_BUILD_AS_DLL" } )
	--end
elseif ( OS == "linux" ) then											-- LINUX
	table.insert( package.defines, { "LUA_USE_LINUX" } )
	table.insert( package.links, { "dl", "m", "readline", "history", "ncurses" } )
	table.insert( package.linkoptions, { "-Wl,-E" } )
else																-- MACOSX
	table.insert( package.defines, { "LUA_USE_MACOSX" } )
end
