package.name							= "Lua"
package.language						= "c"
package.kind							= "exe"
package.target							= "lua"
package.config["Debug"].target   		= package.target .. "d"
package.config["DllDebug"].target		= package.target .. "d"

-- COMPILER SETTINGS ----------------------------------------------------------
--
-- Build Flags
package.config["Debug"].buildflags 		= { "static-runtime" }
package.config["Release"].buildflags	= { "static-runtime", "no-symbols", "optimize-size" }
package.config["DllRelease"].buildflags	= { "no-symbols", "optimize-size" }

-- Defined Symbols
package.config["Debug"].defines			= { "DEBUG", "_DEBUG" }
package.config["DllDebug"].defines		= { "DEBUG", "_DEBUG" }
package.config["Release"].defines		= { "NDEBUG" }
package.config["DllRelease"].defines	= { "NDEBUG" }

-- Set the objects directories.
package.objdir							= ".obj"

-- Files
package.files							= { "lua.c", matchfiles( "*.h" ) }
package.excludes						= { "luac.c" }

-- Include paths
-- all files are included in one directory
--package.includepaths					= { "include" }

-- LINKER SETTINGS ------------------------------------------------------------
--
-- Libraries to link against.
package.links							= { "LuaLib" }

-- Linker directory paths.
-- all files are included in one directory
--package.libpaths						= { "lua" }

-- COMPILER SPECIFIC SETUP ----------------------------------------------------
--
if ( ( target == "gnu" ) or ( target == "cb-gcc" ) ) then
	table.insert( package.buildflags, "extra-warnings" )
	table.insert( package.buildoptions, { "-W" } )
end

if ( target == "vs2005" ) then
	-- Windows and Visual C++ 2005
	table.insert( package.defines, "_CRT_SECURE_NO_DEPRECATE" )
end

-- OPERATING SYSTEM SPECIFIC SETTINGS -----------------------------------------
--
if ( OS == "windows" ) then											-- WINDOWS
	table.insert( package.files, { "lua.rc" } )
	table.insert( package.defines, { "_WIN32", "WIN32", "_WINDOWS" } )
	table.insert( package.config["DllDebug"].defines, { "LUA_BUILD_AS_DLL" } )
	table.insert( package.config["DllRelease"].defines, { "LUA_BUILD_AS_DLL" } )
elseif ( OS == "linux" ) then										-- LINUX
	table.insert( package.defines, { "LUA_USE_LINUX" } )
	table.insert( package.links, { "dl", "readline", "history", "ncurses" } )
	table.insert( package.linkoptions, { "-Wl,-E" } )
else																-- MACOSX
	table.insert( package.defines, { "LUA_USE_MACOSX" } )
end
