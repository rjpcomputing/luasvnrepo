-- ---------------------------------------------------------------------------
-- tolua++lib.lua - Premake script to generate build files for the toLua++
--                  static libraries.
--
-- Copyright (c) 2008 Ryan Pusztai.
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to
-- deal in the Software without restriction, including without limitation the
-- rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
-- sell copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
-- FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
-- IN THE SOFTWARE.
-- ---------------------------------------------------------------------------

-- OPTIONS -------------------------------------------------------------------
--
addoption( "tolua++-cpp", "Compile toLua++ library as C++ code." )

-- GENERAL SETUP -------------------------------------------------------------
--
package.name								= "toLua++Lib"
if ( options["tolua++-cpp"] ) then
	package.language						= "c++"
else
	package.language						= "c"
end
package.kind								= "lib"
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
package.files								= {
												matchfiles( "*.c","*.h" ),
												"../../include/tolua++.h"
											  }

-- Include paths
-- <toLua incude path>, <Lua's include path>
package.includepaths						= { "../../include", "../../../lua" }

-- LINKER SETTINGS ------------------------------------------------------------
--
-- Libraries to link against.
--package.links 							= { "" }

-- Linker directory paths.
--package.libpaths 							= { "" }

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
	--table.insert( package.links, { "pthread", "dl" } )
else																-- MACOSX
end
