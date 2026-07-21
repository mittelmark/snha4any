%{
/* --- Internal Helper: Tcl List -> GList of strduped strings --- */
static GList* tcl_to_glist_str(Tcl_Obj *list_obj) {
    Tcl_Size objc = 0;
    Tcl_Obj **objv = NULL;
    GList *list = NULL;
    Tcl_Size i;

    if (Tcl_ListObjGetElements(NULL, list_obj, &objc, &objv) != TCL_OK) return NULL;
    
    for (i = 0; i < objc; i++) {
        char *str = Tcl_GetString(objv[i]);
        if (str) {
            list = g_list_append(list, g_strdup(str));
        }
    }
    return list;
}

/* --- Internal Helper: Tcl List -> GList of integers (GINT_TO_POINTER) --- */
static GList* tcl_to_glist_int(Tcl_Obj *list_obj) {
    Tcl_Size objc = 0;
    Tcl_Obj **objv = NULL;
    GList *list = NULL;
    Tcl_Size i;

    if (Tcl_ListObjGetElements(NULL, list_obj, &objc, &objv) != TCL_OK) return NULL;
    
    for (i = 0; i < objc; i++) {
        int val;
        if (Tcl_GetIntFromObj(NULL, objv[i], &val) == TCL_OK) {
            list = g_list_append(list, GINT_TO_POINTER(val));
        }
    }
    return list;
}

/* --- Internal Helper: GList of strings -> Tcl List --- */
static Tcl_Obj* glist_to_tcl_str(GList *list) {
    Tcl_Obj *listPtr = Tcl_NewListObj(0, NULL);
    GList *curr;
    for (curr = list; curr != NULL; curr = curr->next) {
        Tcl_ListObjAppendElement(NULL, listPtr, Tcl_NewStringObj((char*)curr->data, -1));
    }
    return listPtr;
}

/* --- Internal Helper: GList of integers -> Tcl List --- */
static Tcl_Obj* glist_to_tcl_int(GList *list) {
    Tcl_Obj *listPtr = Tcl_NewListObj(0, NULL);
    GList *curr;
    for (curr = list; curr != NULL; curr = curr->next) {
        Tcl_ListObjAppendElement(NULL, listPtr, Tcl_NewIntObj(GPOINTER_TO_INT(curr->data)));
    }
    return listPtr;
}
%}

/* --- Tcl Command Wrappers --- */
/* These use the _tcl suffix defined in the %rename block of glist.i */

%inline %{

void print_list_str_tcl(Tcl_Obj *list_obj) {
    GList *list = tcl_to_glist_str(list_obj);
    if (list) {
        /* Call the real C function from glist.h */
        print_list_str(list);
        /* Cleanup: free strduped strings and list nodes */
        g_list_free_full(list, (GDestroyNotify)g_free);
    }
}

int sum_list_int_tcl(Tcl_Obj *list_obj) {
    GList *list = tcl_to_glist_int(list_obj);
    int result = 0;
    if (list) {
        result = sum_list_int(list);
        /* Cleanup: free list nodes only (integers are in the pointers) */
        g_list_free(list);
    }
    return result;
}

Tcl_Obj* get_sample_list_str_tcl() {
    /* Get the list from the real C function */
    GList *list = get_sample_list_str();
    Tcl_Obj *res = glist_to_tcl_str(list);
    /* Note: If the C function creates a fresh list, you might need to free it here */
    return res;
}

Tcl_Obj* get_sample_list_int_tcl() {
    GList *list = get_sample_list_int();
    Tcl_Obj *res = glist_to_tcl_int(list);
    return res;
}

%}

%rename(sum_list_int)        sum_list_int_tcl;
