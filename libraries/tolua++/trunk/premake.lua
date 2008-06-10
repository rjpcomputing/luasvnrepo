-- ---------------------------------------------------------------------------
-- premake.lua - Premake script to generate build files for all the toLua++
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
project.name     = "toLua++"
project.bindir   = "bin"
project.libdir   = "lib"

-- Configureations. All I am doing is reordering them so that
-- it defaults to a Release build.
project.configs = { "Release", "Debug" }

-- Project Packages
dopackage( "src/bin/tolua++exe" )
dopackage( "src/lib/tolua++lib" )
dopackage( "../lua/lualib" )				-- This path might need to change.

-- Add options here.
addoption( "dynamic-runtime", "Use the dynamicly loadable version of the runtime." )
