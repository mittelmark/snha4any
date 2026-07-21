%{
/* Helper function for g_tree_foreach to populate Lua table (String Tree) */
static gboolean tree_to_lua_table_str(gpointer key, gpointer value, gpointer data) {
    lua_State *L = (lua_State *)data;
    lua_pushstring(L, (const char *)key);
    lua_pushstring(L, (const char *)value);
    lua_settable(L, -3);
    return FALSE; 
}

/* Helper function for g_tree_foreach to populate Lua table (Int Tree) */
static gboolean tree_to_lua_table_int(gpointer key, gpointer value, gpointer data) {
    lua_State *L = (lua_State *)data;
    lua_pushstring(L, (const char *)key);
    lua_pushinteger(L, GPOINTER_TO_INT(value));
    lua_settable(L, -3);
    return FALSE; 
}
%}

/* ================================================================= 
   GTreeStr (String keys, String values)
   ================================================================= */

%typemap(in) GTreeStr * {
    if (!lua_istable(L, $input)) return luaL_error(L, "Expected table {string=string}");
    
    /* Use g_tree_new with g_strcmp0 (2 args) to match the compiler's GCompareFunc */
    $1 = (GTreeStr*)g_tree_new((GCompareFunc)g_strcmp0);
    
    lua_pushnil(L);
    while (lua_next(L, $input) != 0) {
        const char *key = luaL_checkstring(L, -2);
        const char *val = luaL_checkstring(L, -1);
        /* Insert copies; C code should be configured to free these if necessary */
        g_tree_insert((GTree*)$1, g_strdup(key), g_strdup(val));
        lua_pop(L, 1);
    }
}

%typemap(out) GTreeStr * {
    lua_newtable(L);
    if ($1) {
        g_tree_foreach((GTree *)$1, (GTraverseFunc)tree_to_lua_table_str, L);
    }
    SWIG_arg++;
}

%typemap(freearg) GTreeStr * {
    if ($1) g_tree_destroy((GTree*)$1);
}

/* ================================================================= 
   GTreeInt (String keys, Integer values)
   ================================================================= */

%typemap(in) GTreeInt * {
    if (!lua_istable(L, $input)) return luaL_error(L, "Expected table {string=number}");
    
    $1 = (GTreeInt*)g_tree_new((GCompareFunc)g_strcmp0);
    
    lua_pushnil(L);
    while (lua_next(L, $input) != 0) {
        const char *key = luaL_checkstring(L, -2);
        int val = (int)luaL_checkinteger(L, -1);
        g_tree_insert((GTree*)$1, g_strdup(key), GINT_TO_POINTER(val));
        lua_pop(L, 1);
    }
}

%typemap(out) GTreeInt * {
    lua_newtable(L);
    if ($1) {
        g_tree_foreach((GTree *)$1, (GTraverseFunc)tree_to_lua_table_int, L);
    }
    SWIG_arg++;
}

%typemap(freearg) GTreeInt * {
    if ($1) g_tree_destroy((GTree*)$1);
}
