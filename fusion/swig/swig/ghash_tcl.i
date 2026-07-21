/* ================================================================= 
   STR-STR TYPEMAPS (Dictionary <-> GHashTable)
   ================================================================= */

%typemap(in) GHashStrStr * {
    Tcl_Obj *keyPtr, *valuePtr;
    Tcl_DictSearch search;
    int done;

    if (Tcl_DictObjFirst(interp, $input, &search, &keyPtr, &valuePtr, &done) != TCL_OK) {
        return TCL_ERROR;
    }

    /* Key: String (g_free), Value: String (g_free) */
    $1 = g_hash_table_new_full(g_str_hash, g_str_equal, g_free, g_free);

    for (; !done; Tcl_DictObjNext(&search, &keyPtr, &valuePtr, &done)) {
        g_hash_table_insert($1, g_strdup(Tcl_GetString(keyPtr)), g_strdup(Tcl_GetString(valuePtr)));
    }
}

%typemap(out) GHashStrStr * {
    Tcl_Obj *dictPtr = Tcl_NewDictObj();
    if ($1) {
        GHashTableIter iter;
        gpointer key, value;
        g_hash_table_iter_init(&iter, $1);
        while (g_hash_table_iter_next(&iter, &key, &value)) {
            Tcl_DictObjPut(interp, dictPtr, 
                           Tcl_NewStringObj((char*)key, -1), 
                           Tcl_NewStringObj((char*)value, -1));
        }
        g_hash_table_destroy($1);
    }
    Tcl_SetObjResult(interp, dictPtr);
    return TCL_OK;
}

%typemap(freearg) GHashStrStr * {
    if ($1) g_hash_table_destroy($1);
}

/* ================================================================= 
   STR-INT TYPEMAPS (Dictionary <-> GHashTable)
   ================================================================= */

%typemap(in) GHashStrInt * {
    Tcl_Obj *keyPtr, *valuePtr;
    Tcl_DictSearch search;
    int done;

    if (Tcl_DictObjFirst(interp, $input, &search, &keyPtr, &valuePtr, &done) != TCL_OK) {
        return TCL_ERROR;
    }

    /* Key: String (g_free), Value: Integer (Stored in pointer, no free) */
    $1 = g_hash_table_new_full(g_str_hash, g_str_equal, g_free, NULL);

    for (; !done; Tcl_DictObjNext(&search, &keyPtr, &valuePtr, &done)) {
        int val;
        Tcl_GetIntFromObj(interp, valuePtr, &val);
        g_hash_table_insert($1, g_strdup(Tcl_GetString(keyPtr)), GINT_TO_POINTER(val));
    }
}

%typemap(out) GHashStrInt * {
    Tcl_Obj *dictPtr = Tcl_NewDictObj();
    if ($1) {
        GHashTableIter iter;
        gpointer key, value;
        g_hash_table_iter_init(&iter, $1);
        while (g_hash_table_iter_next(&iter, &key, &value)) {
            Tcl_DictObjPut(interp, dictPtr, 
                           Tcl_NewStringObj((char*)key, -1), 
                           Tcl_NewIntObj(GPOINTER_TO_INT(value)));
        }
        g_hash_table_destroy($1);
    }
    Tcl_SetObjResult(interp, dictPtr);
    return TCL_OK;
}

%typemap(freearg) GHashStrInt * {
    if ($1) g_hash_table_destroy($1);
}

/* 3. Create a truly GENERIC count_keys using %inline */
%inline %{
int count_keys(Tcl_Obj *dict_obj) {
    Tcl_Size size;
    /* This works on ANY Tcl Dictionary, regardless of what's inside */
    if (Tcl_DictObjSize(NULL, dict_obj, &size) != TCL_OK) {
        return -1; 
    }
    return (int)size;
}
%}

/* Typemap: StrBool (Tcl Dict -> GHashStrBool) */
%typemap(in) GHashStrBool * {
    Tcl_DictSearch search; Tcl_Obj *k, *v; int done;
    if (Tcl_DictObjFirst(interp, $input, &search, &k, &v, &done) != TCL_OK) {
        SWIG_fail;
    }
    
    $1 = g_hash_table_new_full(g_str_hash, g_str_equal, g_free, NULL);
    for (; !done; Tcl_DictObjNext(&search, &k, &v, &done)) {
        int bval;
        if (Tcl_GetBooleanFromObj(interp, v, &bval) != TCL_OK) {
            g_hash_table_destroy($1);
            SWIG_fail;
        }
        g_hash_table_insert($1, g_strdup(Tcl_GetString(k)), GINT_TO_POINTER(bval));
    }
}

/* Typemap: GHashStrBool -> Tcl Dict */
%typemap(out) GHashStrBool * {
    Tcl_Obj *dictPtr = Tcl_NewDictObj();
    if ($1) {
        GHashTableIter iter; gpointer k, v;
        g_hash_table_iter_init(&iter, $1);
        while (g_hash_table_iter_next(&iter, &k, &v)) {
            Tcl_DictObjPut(interp, dictPtr, 
                           Tcl_NewStringObj((char*)k, -1), 
                           Tcl_NewBooleanObj(GPOINTER_TO_INT(v)));
        }
        g_hash_table_destroy($1);
    }
    Tcl_SetObjResult(interp, dictPtr);
}

/* Typemap: StrFloat (Tcl Dict -> GHashStrFloat) */
%typemap(in) GHashStrFloat * {
    Tcl_DictSearch search; Tcl_Obj *k, *v; int done;
    if (Tcl_DictObjFirst(interp, $input, &search, &k, &v, &done) != TCL_OK) {
        SWIG_fail;
    }
    
    $1 = g_hash_table_new_full(g_str_hash, g_str_equal, g_free, g_free);
    for (; !done; Tcl_DictObjNext(&search, &k, &v, &done)) {
        double dval;
        if (Tcl_GetDoubleFromObj(interp, v, &dval) != TCL_OK) {
            g_hash_table_destroy($1);
            SWIG_fail;
        }
        float *f_ptr = g_new(float, 1);
        *f_ptr = (float)dval;
        g_hash_table_insert($1, g_strdup(Tcl_GetString(k)), f_ptr);
    }
}

/* Typemap: GHashStrFloat -> Tcl Dict */
%typemap(out) GHashStrFloat * {
    Tcl_Obj *dictPtr = Tcl_NewDictObj();
    if ($1) {
        GHashTableIter iter; gpointer k, v;
        g_hash_table_iter_init(&iter, $1);
        while (g_hash_table_iter_next(&iter, &k, &v)) {
            Tcl_DictObjPut(interp, dictPtr, 
                           Tcl_NewStringObj((char*)k, -1), 
                           Tcl_NewDoubleObj((double)(*(float*)v)));
        }
        g_hash_table_destroy($1);
    }
    Tcl_SetObjResult(interp, dictPtr);
}
