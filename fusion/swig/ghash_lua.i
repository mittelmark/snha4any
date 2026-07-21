/* 1. Lua-specific Generic Count */
/* ghash_lua.i */

/* Alternative simpler way: Use the 'L' name directly in the signature 
   but define the function as taking NO arguments in the wrapper. */
%native(count_keys) int count_keys_lua(lua_State *L);

%{
    int count_keys_lua(lua_State *L) {
        if (!lua_istable(L, 1)) {
            lua_pushinteger(L, 0);
            return 1;
        }
        int count = 0;
        lua_pushnil(L);
        while (lua_next(L, 1) != 0) {
            count++;
            lua_pop(L, 1);
        }
        lua_pushinteger(L, count);
        return 1;
    }
%}

/* 2. Typemap: StrStr (Lua Table -> GHashStrStr) */
%typemap(in) GHashStrStr * {
    if (!lua_istable(L, $input)) return luaL_error(L, "Expected table");
    $1 = g_hash_table_new_full(g_str_hash, g_str_equal, g_free, g_free);
    lua_pushnil(L);
    while (lua_next(L, $input) != 0) {
        g_hash_table_insert($1, g_strdup(luaL_checkstring(L, -2)), g_strdup(luaL_checkstring(L, -1)));
        lua_pop(L, 1);
    }
}
%typemap(freearg) GHashStrStr * { if ($1) g_hash_table_destroy($1); }

/* 3. Typemap: StrInt (Lua Table -> GHashStrInt) */
%typemap(in) GHashStrInt * {
    if (!lua_istable(L, $input)) return luaL_error(L, "Expected table");
    $1 = g_hash_table_new_full(g_str_hash, g_str_equal, g_free, NULL);
    lua_pushnil(L);
    while (lua_next(L, $input) != 0) {
        g_hash_table_insert($1, g_strdup(luaL_checkstring(L, -2)), GINT_TO_POINTER((int)luaL_checkinteger(L, -1)));
        lua_pop(L, 1);
    }
}
%typemap(freearg) GHashStrInt * { if ($1) g_hash_table_destroy($1); }

/* GHashStrStr -> Lua Table */
%typemap(out) GHashStrStr * {
    lua_newtable(L);
    if ($1) {
        GHashTableIter iter; gpointer key, value;
        g_hash_table_iter_init(&iter, $1);
        while (g_hash_table_iter_next(&iter, &key, &value)) {
            lua_pushstring(L, (char*)value);
            lua_setfield(L, -2, (char*)key);
        }
        g_hash_table_destroy($1);
    }
    SWIG_arg++; // Inform Lua we returned 1 item on stack
}

/* GHashStrInt -> Lua Table */
%typemap(out) GHashStrInt * {
    lua_newtable(L);
    if ($1) {
        GHashTableIter iter; gpointer key, value;
        g_hash_table_iter_init(&iter, $1);
        while (g_hash_table_iter_next(&iter, &key, &value)) {
            lua_pushinteger(L, GPOINTER_TO_INT(value));
            lua_setfield(L, -2, (char*)key);
        }
        g_hash_table_destroy($1);
    }
    SWIG_arg++;
}

/* Typemap: StrBool (Lua Table -> GHashStrBool) */
%typemap(in) GHashStrBool * {
    if (!lua_istable(L, $input)) return luaL_error(L, "Expected table");
    
    /* Value destructor is NULL because we use GINT_TO_POINTER */
    $1 = g_hash_table_new_full(g_str_hash, g_str_equal, g_free, NULL);
    
    lua_pushnil(L);
    while (lua_next(L, $input) != 0) {
        /* lua_toboolean returns 1 for true, 0 for false */
        int val = lua_toboolean(L, -1);
        const char *key = luaL_checkstring(L, -2);
        
        g_hash_table_insert($1, g_strdup(key), GINT_TO_POINTER(val));
        lua_pop(L, 1);
    }
}

/* Typemap: GHashStrBool -> Lua Table */
%typemap(out) GHashStrBool * {
    lua_newtable(L);
    if ($1) {
        GHashTableIter iter; gpointer k, v;
        g_hash_table_iter_init(&iter, $1);
        while (g_hash_table_iter_next(&iter, &k, &v)) {
            lua_pushboolean(L, GPOINTER_TO_INT(v));
            lua_setfield(L, -2, (char*)k);
        }
        g_hash_table_destroy($1);
    }
    SWIG_arg++;
}

/* Typemap: StrFloat (Lua Table -> GHashStrFloat) */
%typemap(in) GHashStrFloat * {
    if (!lua_istable(L, $input)) return luaL_error(L, "Expected table");
    
    /* We use g_free as the value-destroyer to clean up the allocated floats */
    $1 = g_hash_table_new_full(g_str_hash, g_str_equal, g_free, g_free);
    
    lua_pushnil(L);
    while (lua_next(L, $input) != 0) {
        float *f_ptr = g_new(float, 1);
        *f_ptr = (float)luaL_checknumber(L, -1);
        const char *key = luaL_checkstring(L, -2);
        
        g_hash_table_insert($1, g_strdup(key), f_ptr);
        lua_pop(L, 1);
    }
}

/* Typemap: GHashStrFloat -> Lua Table */
%typemap(out) GHashStrFloat * {
    lua_newtable(L);
    if ($1) {
        GHashTableIter iter; gpointer k, v;
        g_hash_table_iter_init(&iter, $1);
        while (g_hash_table_iter_next(&iter, &k, &v)) {
            /* De-reference the float pointer stored in the hash */
            lua_pushnumber(L, (double)(*(float*)v));
            lua_setfield(L, -2, (char*)k);
        }
        g_hash_table_destroy($1);
    }
    SWIG_arg++;
}
