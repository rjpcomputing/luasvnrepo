-- OPTIONS -------------------------------------------------------------------
--
addoption( "ex-shared", "Create a dynamicly loadable version (dll) of lua-ex." )
addoption( "ex-lua-src",   "Path to the Lua src directory. (default: ../lua)" )

-- GENERAL SETUP -------------------------------------------------------------
--
package.name							= "ex"
package.language						= "c"
if options["ex-shared"] then
	package.kind						= "dll"
else
	package.kind						= "lib"
end
package.target							= package.name
package.config["Debug"].target			= package.target .. "d"

-- COMPILER SETTINGS ----------------------------------------------------------
--
-- Build Flags
if options["dynamic-runtime"] then
	package.config["Release"].buildflags	= { "no-symbols", "optimize" }
else
	package.config["Debug"].buildflags		= { "static-runtime" }
	package.config["Release"].buildflags	= { "static-runtime", "no-symbols", "optimize" }
end

if options["ex-shared"] then
	if ( target == "gnu" ) or ( string.find( target, ".*-gcc" ) ) then
		table.insert( package.buildflags, { "no-import-lib" } )
	end
end

-- Defined Symbols
package.config["Debug"].defines			= { "DEBUG", "_DEBUG" }
package.config["Release"].defines		= { "NDEBUG" }

-- Set the objects directories.
package.objdir							= ".obj"

-- Files
if windows then
	package.files						= { matchrecursive( "w32api/*.h", "w32api/*.c" ) }
else
	package.files						= { "posix/ex.c", "posix/ex.h", "posix/spawn.c", "posix/spawn.h" }
end

-- Include paths
package.includepaths					= { ( options["ex-lua-src"] or "../lua" ) }

-- LINKER SETTINGS ------------------------------------------------------------
--
-- Libraries to link against.
if options["ex-shared"] then
	package.links						= { "LuaLib" }
end

-- Linker directory paths.
-- all files are included in one directory
if options["ex-shared"] then
	package.libpaths					= { "lib", "../lib" }
end

-- COMPILER SPECIFIC SETUP ----------------------------------------------------
--
if ( target == "gnu" ) or ( string.find( target, ".*-gcc" ) ) then
	table.insert( package.buildflags, { "extra-warnings", "no-import-lib" } )
	table.insert( package.buildoptions, { "-W" } )
end

if ( target == "vs2005" ) or ( target == "vs2008" ) then
	table.insert( package.defines, { "_CRT_SECURE_NO_DEPRECATE" } )
	table.insert( package.linkoptions, { "/DEF:ex.def" } )
end

-- OPERATING SYSTEM SPECIFIC SETTINGS -----------------------------------------
--
if windows then														-- WINDOWS
	table.insert( package.defines, { "WIN32_LEAN_AND_MEAN", "NOGDI", "_WIN32", "WIN32", "_WINDOWS" } )
	--table.insert( package.links, { "psapi", "ws2_32" } )
elseif linux then													-- LINUX
	-- Might need to define this on some Linux distros. And comment out the exclude files list.
	-- "MISSING_POSIX_SPAWN"
	table.insert( package.defines, { "ENVIRON_DECL", "_XOPEN_SOURCE=600" } )
	table.insert( package.links, { "pthread", "dl" } )
else																-- MACOSX
end
