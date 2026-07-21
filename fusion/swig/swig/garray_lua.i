/* ================================================================= 
   STRINGS (GStringArray)
   ================================================================= */
%typemap(in) GStringArray * {
    if (!lua_istable(L, $input)) return luaL_error(L, "Expected table of strings");
    size_t len = lua_objlen(L, $input);
    $1 = g_array_new(FALSE, FALSE, sizeof(char*));
    for (size_t i = 1; i <= len; i++) {
        lua_rawgeti(L, $input, i);
        /* lua_tostring provides a pointer; we MUST copy it for the GArray */
        char *s_copy = g_strdup(luaL_checkstring(L, -1));
        g_array_append_val($1, s_copy);
        lua_pop(L, 1);
    }
}

%typemap(out) GStringArray * {
    lua_newtable(L);
    if ($1) {
        for (guint i = 0; i < $1->len; i++) {
            char* s = g_array_index($1, char*, i);
            lua_pushstring(L, s);
            lua_rawseti(L, -2, i + 1);
            g_free(s); /* Clean up C string after pushing to Lua */
        }
        g_array_free($1, TRUE);
    }
    SWIG_arg++;
}

%typemap(freearg) GStringArray * {
    if ($1) {
        for (guint i = 0; i < $1->len; i++) g_free(g_array_index($1, char*, i));
        g_array_free($1, TRUE);
    }
}

/* ================================================================= 
   BOOLEANS (GBoolArray)
   ================================================================= */
%typemap(in) GBoolArray * {
    if (!lua_istable(L, $input)) return luaL_error(L, "Expected table of booleans");
    size_t len = lua_objlen(L, $input);
    $1 = g_array_new(FALSE, FALSE, sizeof(gboolean));
    for (size_t i = 1; i <= len; i++) {
        lua_rawgeti(L, $input, i);
        gboolean val = (gboolean)lua_toboolean(L, -1);
        g_array_append_val($1, val);
        lua_pop(L, 1);
    }
}

%typemap(out) GBoolArray * {
    lua_newtable(L);
    if ($1) {
        for (guint i = 0; i < $1->len; i++) {
            lua_pushboolean(L, g_array_index($1, gboolean, i));
            lua_rawseti(L, -2, i + 1);
        }
        g_array_free($1, TRUE);
    }
    SWIG_arg++;
}

/* ================================================================= 
   NUMBERS (Re-using our previous logic)
   ================================================================= */
%typemap(in) GFloatArray * {
    size_t len = lua_objlen(L, $input);
    $1 = g_array_new(FALSE, FALSE, sizeof(gfloat));
    for (size_t i = 1; i <= len; i++) {
        lua_rawgeti(L, $input, i);
        gfloat val = (gfloat)luaL_checknumber(L, -1);
        g_array_append_val($1, val);
        lua_pop(L, 1);
    }
}

%typemap(out) GFloatArray * {
    lua_newtable(L);
    if ($1) {
        for (guint i = 0; i < $1->len; i++) {
            lua_pushnumber(L, (double)g_array_index($1, gfloat, i));
            lua_rawseti(L, -2, i + 1);
        }
        g_array_free($1, TRUE);
    }
    SWIG_arg++;
}

/* Cleanup for standard arrays */
%typemap(freearg) GFloatArray *, GBoolArray *, GIntArray * {
    if ($1) g_array_free($1, TRUE);
}

