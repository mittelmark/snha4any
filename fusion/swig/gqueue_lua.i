/* ================================================================= 
   INTEGER QUEUE
   ================================================================= */
%typemap(in) GIntQueue * {
    if (!lua_istable(L, $input)) return luaL_error(L, "Expected table of integers");
    size_t len = lua_objlen(L, $input);
    $1 = g_queue_new();
    for (size_t i = 1; i <= len; i++) {
        lua_rawgeti(L, $input, i);
        int val = (int)luaL_checkinteger(L, -1);
        g_queue_push_tail($1, GINT_TO_POINTER(val));
        lua_pop(L, 1);
    }
}

%typemap(out) GIntQueue * {
    lua_newtable(L);
    if ($1) {
        int i = 1;
        GList *l;
        for (l = $1->head; l != NULL; l = l->next) {
            lua_pushinteger(L, GPOINTER_TO_INT(l->data));
            lua_rawseti(L, -2, i++);
        }
        g_queue_free($1); /* Free container, data was just pointers */
    }
    SWIG_arg++;
}

/* ================================================================= 
   BOOLEAN QUEUE
   ================================================================= */
%typemap(in) GBoolQueue * {
    if (!lua_istable(L, $input)) return luaL_error(L, "Expected table of booleans");
    size_t len = lua_objlen(L, $input);
    $1 = g_queue_new();
    for (size_t i = 1; i <= len; i++) {
        lua_rawgeti(L, $input, i);
        g_queue_push_tail($1, GINT_TO_POINTER(lua_toboolean(L, -1)));
        lua_pop(L, 1);
    }
}

%typemap(out) GBoolQueue * {
    lua_newtable(L);
    if ($1) {
        int i = 1;
        GList *l;
        for (l = $1->head; l != NULL; l = l->next) {
            lua_pushboolean(L, GPOINTER_TO_INT(l->data));
            lua_rawseti(L, -2, i++);
        }
        g_queue_free($1);
    }
    SWIG_arg++;
}

/* ================================================================= 
   FLOAT QUEUE (Handling allocated memory for precision)
   ================================================================= */
%typemap(in) GFloatQueue * {
    if (!lua_istable(L, $input)) return luaL_error(L, "Expected table of numbers");
    size_t len = lua_objlen(L, $input);
    $1 = g_queue_new();
    for (size_t i = 1; i <= len; i++) {
        lua_rawgeti(L, $input, i);
        float *f = g_new(float, 1);
        *f = (float)luaL_checknumber(L, -1);
        g_queue_push_tail($1, f);
        lua_pop(L, 1);
    }
}

%typemap(out) GFloatQueue * {
    lua_newtable(L);
    if ($1) {
        int i = 1;
        GList *l;
        for (l = $1->head; l != NULL; l = l->next) {
            lua_pushnumber(L, *(float*)(l->data));
            lua_rawseti(L, -2, i++);
            g_free(l->data); /* Free the allocated float */
        }
        g_queue_free($1);
    }
    SWIG_arg++;
}

/* ================================================================= 
   STRING QUEUE
   ================================================================= */
%typemap(in) GStringQueue * {
    if (!lua_istable(L, $input)) return luaL_error(L, "Expected table of strings");
    size_t len = lua_objlen(L, $input);
    $1 = g_queue_new();
    for (size_t i = 1; i <= len; i++) {
        lua_rawgeti(L, $input, i);
        g_queue_push_tail($1, g_strdup(luaL_checkstring(L, -1)));
        lua_pop(L, 1);
    }
}

%typemap(out) GStringQueue * {
    lua_newtable(L);
    if ($1) {
        int i = 1;
        GList *l;
        for (l = $1->head; l != NULL; l = l->next) {
            lua_pushstring(L, (char*)l->data);
            lua_rawseti(L, -2, i++);
            g_free(l->data); /* Free strduped string */
        }
        g_queue_free($1);
    }
    SWIG_arg++;
}

/* Cleanup for input queues to prevent leaks if the function doesn't free them */
%typemap(freearg) GStringQueue * {
    if ($1) g_queue_free_full($1, (GDestroyNotify)g_free);
}
%typemap(freearg) GFloatQueue * {
    if ($1) g_queue_free_full($1, (GDestroyNotify)g_free);
}
%typemap(freearg) GIntQueue *, GBoolQueue * {
    if ($1) g_queue_free($1);
}
