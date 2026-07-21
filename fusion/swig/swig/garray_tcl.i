
/* ================================================================= 
   INTEGER TYPEMAPS (GIntArray) - Tcl 8/9 Compatible
   ================================================================= */

%typemap(in) GIntArray * {
    Tcl_Size objc_list;
    Tcl_Obj **objv_list;
    
    /* Get elements using Tcl_Size for Tcl 9 safety */
    if (Tcl_ListObjGetElements(interp, $input, &objc_list, &objv_list) != TCL_OK) {
        return TCL_ERROR;
    }
    
    $1 = g_array_new(FALSE, FALSE, sizeof(gint));
    for (Tcl_Size i = 0; i < objc_list; i++) {
        int val;
        /* Tcl_GetIntFromObj handles standard integer strings */
        if (Tcl_GetIntFromObj(interp, objv_list[i], &val) != TCL_OK) {
            /* If it's not an int, clean up and bail */
            g_array_free($1, TRUE);
            return TCL_ERROR;
        }
        gint gval = (gint)val;
        g_array_append_val($1, gval);
    }
}

%typemap(out) GIntArray * {
    if ($1 == NULL) {
        Tcl_SetObjResult(interp, Tcl_NewObj());
    } else {
        Tcl_Obj *listPtr = Tcl_NewListObj(0, NULL);
        for (guint i = 0; i < $1->len; i++) {
            gint val = g_array_index($1, gint, i);
            /* Create Tcl Integer objects for the return list */
            Tcl_ListObjAppendElement(interp, listPtr, Tcl_NewIntObj((int)val));
        }
        Tcl_SetObjResult(interp, listPtr);
        g_array_free($1, TRUE);
    }
    return TCL_OK;
}


/* ================================================================= 
   FLOAT TYPEMAPS (GFloatArray) - Restored with NaN Handling
   ================================================================= */

%typemap(in) GFloatArray * {
    Tcl_Size objc_list;
    Tcl_Obj **objv_list;
    
    if (Tcl_ListObjGetElements(interp, $input, &objc_list, &objv_list) != TCL_OK) {
        return TCL_ERROR;
    }
    
    $1 = g_array_new(FALSE, FALSE, sizeof(gfloat));
    for (Tcl_Size i = 0; i < objc_list; i++) {
        double val;
        
        /* Try to get a double. If it fails, check if the string is "nan" */
        if (Tcl_GetDoubleFromObj(interp, objv_list[i], &val) != TCL_OK) {
            char *str = Tcl_GetString(objv_list[i]);
            /* Case-insensitive check for "nan" */
            if (strncasecmp(str, "nan", 3) == 0) {
                val = (double)NAN;
                /* Clear the "floating point is not a number" error from the interp */
                Tcl_ResetResult(interp);
            } else {
                /* It's a real error (like "abc") */
                g_array_free($1, TRUE);
                return TCL_ERROR;
            }
        }
        
        gfloat gval = (gfloat)val;
        g_array_append_val($1, gval);
    }
}

%typemap(out) GFloatArray * {
    if ($1 == NULL) {
        Tcl_SetObjResult(interp, Tcl_NewObj());
    } else {
        Tcl_Obj *listPtr = Tcl_NewListObj(0, NULL);
        for (guint i = 0; i < $1->len; i++) {
            gfloat val = g_array_index($1, gfloat, i);
            Tcl_ListObjAppendElement(interp, listPtr, Tcl_NewDoubleObj((double)val));
        }
        Tcl_SetObjResult(interp, listPtr);
        g_array_free($1, TRUE);
    }
    return TCL_OK;
}

/* ================================================================= 
   CLEANUP & DECLARATIONS
   ================================================================= */

/* This frees the temporary GArray created in 'in' typemaps after the C call */
%typemap(freearg) GFloatArray *, GIntArray * {
    if ($1) g_array_free($1, TRUE);
}

/* --- STRING TYPEMAPS --- */
%typemap(in) GStringArray * {
    Tcl_Size objc_list; Tcl_Obj **objv_list;
    if (Tcl_ListObjGetElements(interp, $input, &objc_list, &objv_list) != TCL_OK) return TCL_ERROR;
    $1 = g_array_new(FALSE, FALSE, sizeof(char*));
    for (Tcl_Size i = 0; i < objc_list; i++) {
        char *s_copy = g_strdup(Tcl_GetString(objv_list[i]));
        g_array_append_val($1, s_copy);
    }
}

%typemap(out) GStringArray * {
    Tcl_Obj *listPtr = Tcl_NewListObj(0, NULL);
    if ($1) {
        for (guint i = 0; i < $1->len; i++) {
            char* s = g_array_index($1, char*, i);
            Tcl_ListObjAppendElement(interp, listPtr, Tcl_NewStringObj(s, -1));
            g_free(s); // Free the string after Tcl copies it
        }
        g_array_free($1, TRUE);
    }
    Tcl_SetObjResult(interp, listPtr);
    return TCL_OK;
}

/* --- BOOLEAN TYPEMAPS --- */
%typemap(in) GBoolArray * {
    Tcl_Size objc_list; Tcl_Obj **objv_list;
    if (Tcl_ListObjGetElements(interp, $input, &objc_list, &objv_list) != TCL_OK) return TCL_ERROR;
    $1 = g_array_new(FALSE, FALSE, sizeof(gboolean));
    for (Tcl_Size i = 0; i < objc_list; i++) {
        int val;
        if (Tcl_GetBooleanFromObj(interp, objv_list[i], &val) != TCL_OK) {
            g_array_free($1, TRUE); return TCL_ERROR;
        }
        gboolean gb = (gboolean)val;
        g_array_append_val($1, gb);
    }
}

%typemap(out) GBoolArray * {
    Tcl_Obj *listPtr = Tcl_NewListObj(0, NULL);
    if ($1) {
        for (guint i = 0; i < $1->len; i++) {
            Tcl_ListObjAppendElement(interp, listPtr, Tcl_NewBooleanObj(g_array_index($1, gboolean, i)));
        }
        g_array_free($1, TRUE);
    }
    Tcl_SetObjResult(interp, listPtr);
    return TCL_OK;
}

/* Cleanup for input arrays */
%typemap(freearg) GStringArray * {
    if ($1) {
        for (guint i = 0; i < $1->len; i++) g_free(g_array_index($1, char*, i));
        g_array_free($1, TRUE);
    }
}
%typemap(freearg) GBoolArray * { if ($1) g_array_free($1, TRUE); }

