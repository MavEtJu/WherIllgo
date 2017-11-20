//
//  lwherigolib.h
//  luatest
//
//  Created by Edwin Groothuis on 17/7/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#ifndef lwherigolib_h
#define lwherigolib_h

#include <stdio.h>

#define LUA_WIGINTERNAL "WIGInternal"

LUALIB_API int luaopen_WIGInternal (lua_State *L);

#endif /* lwherigolib_h */
