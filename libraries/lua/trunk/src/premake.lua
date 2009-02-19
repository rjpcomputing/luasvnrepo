-- ---------------------------------------------------------------------------
-- premake.lua - Premake script to generate build files for all the Lua
--               libraries and executables.
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

-- Project Settings
project.name     = "Lua"
project.bindir   = "bin"
project.libdir   = "lib"

-- Configurations options
project.configs = { "Release", "Debug" }

-- Project Packages
dopackage( "lualib.lua" )
dopackage( "luaexe.lua" )
dopackage( "luacompiler.lua" )

-- OPTIONS
addoption( "dynamic-runtime", "Use the dynamicly loadable version of the runtime." )


