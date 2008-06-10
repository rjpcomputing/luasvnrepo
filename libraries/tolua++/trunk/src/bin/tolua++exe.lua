-- GENERAL SETUP -------------------------------------------------------------
--
package.name								= "toLua++Exe"
package.language							= "c"
package.kind								= "exe"
package.bindir								= "../../bin"
package.target								= "tolua++"
package.config["Debug"].target				= "toluad++"

-- COMPILER SETTINGS ----------------------------------------------------------
--
-- Build Flags
package.buildflags							= { "seh-exceptions" }
if ( options["dynamic-runtime"] ) then
	package.config["Release"].buildflags	= { "no-symbols", "optimize" }
else
	package.config["Debug"].buildflags		= { "static-runtime" }
	package.config["Release"].buildflags	= { "static-runtime", "no-symbols", "optimize" }
end

-- Defined Symbols
package.config["Debug"].defines				= { "DEBUG", "_DEBUG" }
package.config["Release"].defines			= { "NDEBUG" }

-- Set the objects directories.
package.objdir								= ".obj"

-- Files
package.files								= { "tolua.c", "toluabind.c", "toluabind.h", "../../include/tolua++.h" }

-- Include paths
-- <toLua incude path>, <Lua's include path>
package.includepaths						= { "../../include", "../../../lua" }

-- LINKER SETTINGS ------------------------------------------------------------
--
-- Libraries to link against.
package.links								= { "toLua++Lib", "LuaLib" }

-- Linker directory paths.
--package.libpaths							= { "../../../lua/lib" }

-- COMPILER SPECIFIC SETUP ----------------------------------------------------
--
if ( ( target == "gnu" ) or ( target == "cb-gcc" ) ) then
	table.insert( package.buildflags, { "extra-warnings" } )
	table.insert( package.buildoptions, { "-W" } )
end

if ( ( target == "vs2005" ) or ( target == "vs2008" ) ) then
	-- Windows and Visual C++ 2005/2008
	table.insert( package.defines, "_CRT_SECURE_NO_DEPRECATE" )
end

if ( ( target == "vs2005" ) or ( target == "vs2003" ) or ( target == "vs2008" ) ) then
	table.insert( package.config["Debug"].linkoptions, "/NODEFAULTLIB:LIBCMT" )
end

-- OPERATING SYSTEM SPECIFIC SETTINGS -----------------------------------------
--
if ( OS == "windows" ) then											-- WINDOWS
	table.insert( package.defines, { "_WIN32", "WIN32", "_WINDOWS" } )
elseif ( OS == "linux" ) then										-- LINUX
	table.insert( package.links, { "m", "dl" } )
else																-- MACOSX
end
