//
//  lenvlib.h
//  luatest
//
//  Created by Edwin Groothuis on 17/7/17.
//  Copyright © 2017 Edwin Groothuis. All rights reserved.
//

#ifndef lenvlib_h
#define lenvlib_h

#include <stdio.h>

#define LUA_ENV "Env"

LUALIB_API int luaopen_env (lua_State *L);

#endif /* lenvlib_h */
