/**********************************************************************
 * lunax.h
 *
 * Copyright (c) 2007 Ryan Pusztai.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to
 * deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
 * sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 **********************************************************************/
#ifndef LUNAX_H
#define LUNAX_H

/**	Functions that wrap gtxDeviceComm.
	@file

	C++ library for binding classes into Lua. This is heavily inspired by
	Luna that was created by nornagon (http://lua-users.org/wiki/LunaWrapper).
	It is converted over to use a heavily modified version of Luaxx.h.

	@author	Ryan Pusztai
	@date	06/21/2007

	@version	1.00	Initial concept.

	<b>Example:</b>
	@code
	#include <iostream>
	#include "Lunax.h"

	class Foo
	{
	public:
		Foo( lua_State *L )
		{
			std::cout << "in constructor" << std::endl;
		}

		int foo( lua_State *L )
		{
			std::cout << "in foo" << std::endl;
			return 0;
		}

		~Foo()
		{
			std::cout << "in destructor" << std::endl;
		}

		static const char className[];
		static const Lunax< Foo >::RegType Register[];
	};

    const char Foo::className[] = "Foo";
    const Lunax< Foo >::RegType Foo::Register[] =
	{
		{ "foo", &Foo::foo },
		{ 0 }
    };
	
	int main()
	{
		lua_State* L = luaL_newstate();
		// Initialize the Lua state with all the builtin libraries.
		luaL_openlibs( L );

		std::cout << "Registering functions and class's for 'Foo'..." << endl;
		Lunax<Foo>::Register(L);

		cout << "Calling file 'test.lua'..." << endl;
		luaL_dofile( L, "test.lua" );

		cout << "Closing the Lua state." << endl;
		lua_close( L );
		return 0;
	}
	@endcode

	<b>Lua script (test.lua):</b>
	@code
	local foo = Foo()
    foo:foo()
	@endcode

	<b>Output:</b>
	@code
	Registering functions and class's for 'Foo'...
	Calling file 'test.lua'...
	in constructor
	in foo
	Closing the Lua state.
	in destructor
	@endcode
*/

#include "luaxx.h"

template< class T >
class Lunax
{
public:

	static void Register( lua_State* luaState )
	{
		lua::state lState( luaState );
		lState.push( &Lunax< T >::constructor );
		lState.setglobal( T::className );		// T() in lua will make a new instance.

		lState.newmetatable( T::className );	// create a metatable in the registry
		lState.push( "__gc" );
		lState.push( &Lunax< T >::gc_obj );
		lState.settable( -3 );					// metatable["__gc"] = Lunax<T>::gc_obj
	}

	static int constructor( lua_State* luaState )
	{
		lua::state lState( luaState );
		T* obj = new T( lState );

		lState.newtable();						// create a new table for the class object ('self')

		lState.push( 0 );

		T** a = ( T** )lState.newuserdata( sizeof( T* ) ); // store a ptr to the ptr
		*a = obj;								// set the ptr to the ptr to point to the ptr... >.>
		lState.getmetatable( T::className );	// get the unique metatable
		lState.setmetatable( -2 );				// self.metatable = uniqe_metatable

		lState.settable( -3 );					// self[0] = obj;
		
		// register the functions
		for ( int i = 0; T::Register[i].name; i++ )
		{ 
			lState.push( T::Register[i].name );
			lState.push( i );					// let the thunk know which method we mean
			lState.push( &Lunax<T>::thunk, 1 );
			lState.settable( -3 );				// self["function"] = thunk("function")
		}

		return 1;
	}

	static int thunk( lua_State* luaState )
	{
		lua::state lState( luaState );

		// redirect method call to the real thing
		int i;
		lState.to( i, lua_upvalueindex( 1 ) );	// which function?
		lState.push( 0 );
		lState.gettable( 1 );					// get the class table (i.e, self)

		//T** obj = static_cast< T** >( lState.checkudata( -1, T::className ) );
		T** obj = lState.check< T** >( -1, T::className );
		
		lState.remove( -1 );					// remove the userdata from the stack

		return ( ( *obj )->*( T::Register[i].mfunc ) )( lState ); // execute the thunk
	}

	static int gc_obj( lua_State* luaState )
	{
		lua::state lState( luaState );

		// clean up
		//T** obj = static_cast< T** >( lState.checkudata( -1, T::className ) );
		T** obj = lState.check< T** >( -1, T::className );
		
		delete ( *obj );
		return 0;
	}

	struct RegType
	{
		const char *name;
		int( T::*mfunc )( lua_State* );
	};
};

#endif /* LUNAX_H */
