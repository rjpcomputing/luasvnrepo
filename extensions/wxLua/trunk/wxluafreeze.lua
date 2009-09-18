-- ----------------------------------------------------------------------------
--	Premake script for wxLuaFreeze using a monolithic wxLua library.
--	Author:		RJP Computing <rjpcomputing@gmail.com>
--	Date:		03/20/2008
--	Version:	1.00-beta
--
--	Notes:
--				* Use the '/' slash for all paths.
--				* call ConfigureWxWidgets() after your project is setup,
--				  not before.
-- ----------------------------------------------------------------------------

-- GENERAL SETUP -------------------------------------------------------------
--
package.name								= "wxLuaFreeze"
package.kind								= "winexe"

-- COMPILER SETTINGS ----------------------------------------------------------
--
-- Build Flags
package.buildflags							= { "no-64bit-checks" }

-- Files
package.files								= {
												matchrecursive( "../../apps/wxluafreeze/*.cpp", "../../apps/wxluafreeze/*.h", "../../apps/wxluafreeze/*.rc" )
											  }

package.excludes							= {
												"../../modules/wxbind/src/dummy.cpp",
												matchrecursive( "../../modules/wxbind/setup" ),
												"../../modules/wxlua/src/dummy.cpp",
												"../../modules/wxluadebug/src/dummy.cpp",
												"../../modules/wxluasocket/src/dummy.cpp"
											  }

-- Include paths
package.includepaths						= {
												"../..", "../../modules", "../../modules/wxbind/setup",
												"../../modules/lua/include", "../../modules/lua/src"
											  }

-- LINKER SETTINGS ------------------------------------------------------------
--
-- Libraries to link against.
package.links								= { "wxLua", "LuaLib" }

-- Linker directory paths.
-- all files are included in one directory
package.libpaths							= { "../../bin" }

-- COMPILER SPECIFIC SETUP ----------------------------------------------------
--
if target == "gnu" or string.find( target or "", ".*-gcc" ) then
	table.insert( package.buildoptions, { "-Woverloaded-virtual", "-fno-strict-aliasing", "-fno-pcc-struct-return" } )
end

-- OPERATING SYSTEM SPECIFIC SETTINGS -----------------------------------------
--
if ( OS == "windows" ) then											-- WINDOWS
	table.insert( package.config["Debug"].links, { "wxmsw28d_stc", "wxmsw28d_gl" } )
	table.insert( package.config["Release"].links, { "wxmsw28_stc", "wxmsw28_gl" } )
	table.insert( package.includepaths, { "$(WXWIN)/contrib/include" } )
elseif ( OS == "linux" ) then										-- LINUX
	--table.insert( package.defines, { "" } )
	table.insert( package.config["Debug"].linkoptions, { "`wx-config --debug=yes --libs stc`" } )
	table.insert( package.config["Release"].linkoptions, { "`wx-config --libs stc`" } )
	--table.insert( package.linkoptions, { "-Wl,-E" } )
else																-- MACOSX
	--table.insert( package.defines, { "" } )
end

-- PACKAGE SETUP --------------------------------------------------------------
--
Configure( package )
-- Make this a wxWidgets package.
wx.Configure( package )
