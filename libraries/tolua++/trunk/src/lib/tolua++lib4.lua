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
newoption
{
	trigger = "tolua++-cpp",
	description = "Compile toLua++ library as C++ code."
}

-- GENERAL SETUP -------------------------------------------------------------
--
project								"toLua++Lib"
if _OPTIONS["tolua++-cpp"] then
	language						"c++"
else
	language						"c"
end
kind								"StaticLib"
targetname							"tolua++"
targetdir( solution().basedir .. "/lib" )


-- COMPILER SETTINGS ----------------------------------------------------------
--

-- Build Flags
flags								{ "SEH" }

-- Set the objects directories.
objdir								".obj"

-- Files
files								{
										"*.c",
										"*.h",
										"../../include/tolua++.h"
									}

-- Include paths
-- <toLua incude path>, <Lua's include path>
includedirs							{ "../../include", "../../../lua" }

-- LINKER SETTINGS ------------------------------------------------------------
--
-- Libraries to link against.
--links 							{ "" }

-- Linker directory paths.
--libdirs 							{ "" }

-- OPERATING SYSTEM SPECIFIC SETTINGS -----------------------------------------
--
if os.is( "windows" ) then											-- WINDOWS
	defines			{ "_WIN32", "WIN32", "_WINDOWS" }
elseif os.is( "linux" ) then										-- LINUX
	links			{ "m", "dl" }
	buildoptions	{ "-fPIC" }
else																-- MACOSX
end

-- CONFIGURATIONS ----------------------------------------------------
--
configuration( "gmake or codelite or codeblocks or xcode3" )
	flags( "ExtraWarnings" )
	buildoptions( "-W" )

configuration( "vs2008 or vs2010" )
	-- multi-process building
	flags( "NoMinimalRebuild" )
	buildoptions( "/MP" )

configuration( "vs*" )
	-- Windows and Visual C++ 2005/2008
	defines "_CRT_SECURE_NO_DEPRECATE"

configuration( "Debug", "vs*" )
	linkoptions { "/NODEFAULTLIB:LIBCMT" }

configuration( "not dynamic-runtime" )
	flags "StaticRuntime"

configuration( "Release" )
	defines { "NDEBUG" }
	flags	"Optimize"

configuration( "Debug" )
	targetname "toluad++"
	defines	{ "DEBUG", "_DEBUG" }
	flags	"Symbols"
