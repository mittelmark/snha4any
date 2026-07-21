/* Typemap: GListStr (Lua Table -> GList) */
/* Typemap: GListInt (Lua Table -> GList of Integers) */
%typemap(in) GListInt * {
    if (!lua_istable(L, $input)) {
        /* Use the standard Lua error reporter */
        return luaL_error(L, "Expected a table for GListInt");
    }
    
    $1 = NULL;
    int n = lua_objlen(L, $input); 
    for (int i = 1; i <= n; i++) {
        lua_rawgeti(L, $input, i);
        /* Ensure it's a number before casting */
        if (!lua_isnumber(L, -1)) {
            g_list_free($1); // Clean up partially built list
            return luaL_error(L, "List element at index %d is not a number", i);
        }
        int val = (int)lua_tointeger(L, -1);
        $1 = g_list_append($1, GINT_TO_POINTER(val));
        lua_pop(L, 1);
    }
}
/* Typemap: GListStr (Lua Table -> GList) */
%typemap(in) GListStr * {
    if (!lua_istable(L, $input)) return luaL_error(L, "Expected table");
    $1 = NULL;
    int n = lua_objlen(L, $input); // Uses your compatibility macro
    for (int i = 1; i <= n; i++) {
        lua_rawgeti(L, $input, i);
        $1 = g_list_append($1, g_strdup(luaL_checkstring(L, -1)));
        lua_pop(L, 1);
    }
}

%typemap(freearg) GListStr * {
    if ($1) g_list_free_full($1, g_free);
}

/* Typemap: GListStr -> Lua Table (Array) */
%typemap(out) GListStr * {
    lua_newtable(L);
    GList *l;
    int i = 1;
    for (l = $1; l != NULL; l = l->next) {
        lua_pushstring(L, (char*)l->data);
        lua_rawseti(L, -2, i++);
    }
    if ($1) g_list_free_full($1, g_free);
    SWIG_arg++;
}

/* Typemap: GListInt -> Lua Table (Array) */
%typemap(out) GListInt * {
    lua_newtable(L);
    GList *l;
    int i = 1;
    for (l = $1; l != NULL; l = l->next) {
        lua_pushinteger(L, GPOINTER_TO_INT(l->data));
        lua_rawseti(L, -2, i++);
    }
    if ($1) g_list_free($1);
    SWIG_arg++;
}
