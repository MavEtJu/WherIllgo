/*
 ** $Id: loslib.c,v 1.19.1.3 2008/01/18 16:38:18 roberto Exp $
 ** Standard Operating System library
 ** See Copyright Notice in lua.h
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

#include "lwiginternal.h"

#include "WIG-link.h"

static int wigLogMessage (lua_State *L) {
    const char *s = luaL_checkstring(L, 1);
    printf("Log!\n");
    printf("> text: %s\n", s);
    return 0;
}

static int wigShowStatusText (lua_State *L) {
    const char *s = luaL_checkstring(L, 1);
    printf("StatusText!\n", s);
    printf("> text: %s\n", s);
    return 0;
}

static int wigMessageBox(lua_State *L) {
    const char *text = luaL_checkstring(L, 1);
    const char *media = luaL_checkstring(L, 2);
    const char *button1 = luaL_checkstring(L, 3);
    const char *button2 = luaL_checkstring(L, 4);
    const char *callback = luaL_checkstring(L, 5);
    printf("MessageBox!\n");
    printf("> text: %s\n", text);
    printf("> media: %s\n", media);
    printf("> button1: %s\n", button1);
    printf("> button2: %s\n", button2);
    printf("> callback: %s\n", callback);
    printf("Press OK to continue (fake)\n");
    if (strcmp(callback, "1") == 0)
        WIGMessageBoxCallback();
    return 0;
}

static int wigPlayAudio (lua_State *L) {
    const char *s = luaL_checkstring(L, 1);
    printf("Audio!\n");
    printf("id: %s\n", s);
    return 0;
}

static const luaL_Reg wiginternallib[] = {
    {"LogMessage",      wigLogMessage},
    {"PlayAudio",       wigPlayAudio},
    {"ShowStatusText",  wigShowStatusText},
    {"MessageBox",      wigMessageBox},
    {NULL, NULL}
};

/* }====================================================== */

LUALIB_API int luaopen_WIGInternal (lua_State *L) {
    luaL_register(L, LUA_WIGINTERNAL, wiginternallib);
    return 1;
}


