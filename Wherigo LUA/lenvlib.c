/*
 */

#include <errno.h>
#include <locale.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define loslib_c
#define LUA_LIB

#include "lua.h"

#include "lauxlib.h"
#include "lualib.h"

#include "lenvlib.h"

static int envPlayer(lua_State *L) {
    printf("envPlayer\n");
    exit(luaL_optint(L, 1, 99));
}

static int envCompany(lua_State *L) {
    printf("envCompany\n");
    exit(luaL_optint(L, 1, 99));
}

static int envActivity(lua_State *L) {
    printf("envActivity\n");
    exit(luaL_optint(L, 1, 99));
}

static int envCompletionCode(lua_State *L) {
    printf("envCompletionCode\n");
    exit(luaL_optint(L, 1, 99));
}

static int envPlatform(lua_State *L) {
    lua_pushstring(L, "Geocube");
    return 1;  /* number of results */
}

static const luaL_Reg envlib[] = {
    {"Platform",    envPlatform},
    {"_Player",     envPlayer},
    {"_Company",    envCompany},
    {"_Activity",   envActivity},
    {"_CompletionCode",   envCompletionCode},
    {NULL, NULL}
};

/* }====================================================== */

LUALIB_API int luaopen_env (lua_State *L) {
    luaL_register(L, LUA_ENV, envlib);
    return 1;
}


