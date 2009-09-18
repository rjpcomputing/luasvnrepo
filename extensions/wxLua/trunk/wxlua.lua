-- ----------------------------------------------------------------------------
--	Premake script for wxLua as a monolithic library.
--	Author:		RJP Computing <rjpcomputing@gmail.com>
--	Date:		03/20/2008
--	Version:	1.00-beta
--
--	Notes:
--				* Use the '/' slash for all paths.
--				* call ConfigureWxWidgets() after your project is setup,
--				  not before.
-- ----------------------------------------------------------------------------

-- OPTIONS -------------------------------------------------------------------
--
addoption( "shared", "Create a dynamicly loadable version (dll) of wxLua." )

-- GENERAL SETUP -------------------------------------------------------------
--
package.name								= "wxLua"
if options["shared"] then
	package.kind							= "dll"
else
	package.kind							= "lib"
end

-- COMPILER SETTINGS ----------------------------------------------------------
--
-- Build Flags
package.buildflags							= { "no-64bit-checks" }

-- Defined Symbols
if options["shared"] then
	package.defines							= {
												--"WXMAKINGDLL_LUAMODULE",
												"WXMAKINGDLL_WXLUA",
												--"DLL_EXPORTS",
												"WXMAKINGDLL_WXBINDADV",
												"WXMAKINGDLL_WXBINDAUI",
												"WXMAKINGDLL_WXBINDBASE",
												"WXMAKINGDLL_WXBINDCORE",
												"WXMAKINGDLL_WXBINDGL",
												"WXMAKINGDLL_WXBINDHTML",
												"WXMAKINGDLL_WXBINDMEDIA",
												"WXMAKINGDLL_WXBINDNET",
												"WXMAKINGDLL_WXBINDRICHTEXT",
												"WXMAKINGDLL_WXBINDSTC",
												"WXMAKINGDLL_WXBINDXML",
												"WXMAKINGDLL_WXBINDXRC",
												"WXMAKINGDLL_WXLUADEBUG",
												"WXMAKINGDLL_WXLUASOCKET"
											  }
end

-- Files
package.files								= {
												matchrecursive( "../../modules/wxbind/*.cpp", "../../modules/wxbind/*.h" ),
												matchrecursive( "../../modules/wxlua/*.cpp", "../../modules/wxlua/*.h" ),
												matchrecursive( "../../modules/wxluadebug/*.cpp", "../../modules/wxluadebug/*.h" ),
												matchrecursive( "../../modules/wxluasocket/*.cpp", "../../modules/wxluasocket/*.h" )
											  }

package.excludes							= {
												"../../modules/wxbind/src/dummy.cpp",
												--"../../modules/wxbind/src/wxgl_bind.cpp",
												--"../../modules/wxbind/include/wxgl_bind.h",
												--"../../modules/wxbind/src/wxgl_gl.cpp",
												matchrecursive( "../../modules/wxbind/setup" ),
												"../../modules/wxlua/src/dummy.cpp",
												"../../modules/wxluadebug/src/dummy.cpp",
												"../../modules/wxluasocket/src/dummy.cpp"
											  }

-- Include paths
-- all files are included in one directory
package.includepaths						= {
												"../..", "../../modules", "../../modules/wxbind/setup",
												"../../modules/lua/include", "../../modules/lua/src"
											  }

-- LINKER SETTINGS ------------------------------------------------------------
--
-- Libraries to link against.
package.links								= { "LuaLib" }

-- Linker directory paths.
-- all files are included in one directory
package.libpaths							= { "../../bin" }

-- COMPILER SPECIFIC SETUP ----------------------------------------------------
--
if target == "gnu" or string.find( target or "", ".*-gcc" ) then
	table.insert( package.buildoptions, { "-Woverloaded-virtual", "-fno-strict-aliasing", "-fno-pcc-struct-return" } )

end

--if ( target == "vs2005" or target == "vs2008" ) then
--end

-- OPERATING SYSTEM SPECIFIC SETTINGS -----------------------------------------
--
if OS == "windows" then												-- WINDOWS
	if options["shared"] then
		table.insert( package.config["Debug"].links, { "wxmsw28d_stc", "wxmsw28d_gl" } )
		table.insert( package.config["Release"].links, { "wxmsw28_stc", "wxmsw28_gl" } )
	end
	table.insert( package.includepaths, { "$(WXWIN)/contrib/include" } )
elseif OS == "linux" then
	table.insert( package.config["Debug"].linkoptions, { "`wx-config --debug=yes --libs stc`" } )
	table.insert( package.config["Release"].linkoptions, { "`wx-config --libs stc`" } )
else																-- MACOSX
	--table.insert( package.defines, { "" } )
end

-- PACKAGE SETUP --------------------------------------------------------------
--
Configure( package )
-- Make this a wxWidgets package.
wx.Configure( package )
