%{
/* --- Internal Helper: Tcl Dict/List -> GTree of strings --- */
static GTree* tcl_to_gtree_str(Tcl_Obj *dict_obj) {
    Tcl_Size objc = 0;
    Tcl_Obj **objv = NULL;
    Tcl_Size i;

    /* Tcl dictionaries are effectively lists with even number of elements */
    if (Tcl_ListObjGetElements(NULL, dict_obj, &objc, &objv) != TCL_OK) return NULL;
    if (objc % 2 != 0) return NULL; /* Must be key-value pairs */
    
    /* Use g_tree_new with g_strcmp0 for simpler signature matching 
       to avoid "incompatible pointer type" errors in SWIG wrappers. */
    GTree *tree = g_tree_new((GCompareFunc)g_strcmp0);
    
    for (i = 0; i < objc; i += 2) {
        char *key = Tcl_GetString(objv[i]);
        char *val = Tcl_GetString(objv[i+1]);
        if (key && val) {
            /* We g_strdup because the tree doesn't own the Tcl object's memory */
            g_tree_insert(tree, g_strdup(key), g_strdup(val));
        }
    }
    return tree;
}

/* --- Internal Helper: GTree -> Tcl List (for Return Values) --- */
static gboolean tree_to_tcl_dict(gpointer key, gpointer value, gpointer data) {
    Tcl_Obj *listPtr = (Tcl_Obj *)data;
    Tcl_ListObjAppendElement(NULL, listPtr, Tcl_NewStringObj((char*)key, -1));
    Tcl_ListObjAppendElement(NULL, listPtr, Tcl_NewStringObj((char*)value, -1));
    return FALSE; /* Continue traversal */
}
%}

/* --- Tcl Command Wrappers (Stable Bridge) --- */
/* These map to the %rename directives in gtree.i */

%inline %{

void print_tree_str_tcl(Tcl_Obj *dict_obj) {
    GTree *tree = tcl_to_gtree_str(dict_obj);
    if (tree) {
        /* Cast to specialized type to match gtree.h prototype */
        print_tree_str((GTreeStr*)tree);
        /* Cleanup: Since we used g_tree_new, we destroy the tree here.
           Note: If your C code doesn't free the nodes, you'd need a foreach-free. */
        g_tree_destroy(tree);
    }
}

Tcl_Obj* get_sample_tree_str_tcl() {
    /* Get raw GTree from C */
    GTreeStr *tree = get_sample_tree_str();
    Tcl_Obj *listPtr = Tcl_NewListObj(0, NULL);
    
    if (tree) {
        /* Traverse tree and fill the Tcl list with key-value pairs */
        g_tree_foreach((GTree*)tree, (GTraverseFunc)tree_to_tcl_dict, listPtr);
        /* Bridge owns the conversion, so we free the C tree after building the Tcl Obj */
        g_tree_destroy((GTree*)tree);
    }
    return listPtr;
}

int sum_tree_int_tcl(Tcl_Obj *dict_obj) {
    Tcl_Size objc = 0;
    Tcl_Obj **objv = NULL;
    int result = 0;

    if (Tcl_ListObjGetElements(NULL, dict_obj, &objc, &objv) == TCL_OK && objc % 2 == 0) {
        /* Match the g_tree_new pattern for integer values as well */
        GTree *tree = g_tree_new((GCompareFunc)g_strcmp0);
        for (Tcl_Size i = 0; i < objc; i += 2) {
            int val;
            Tcl_GetIntFromObj(NULL, objv[i+1], &val);
            g_tree_insert(tree, g_strdup(Tcl_GetString(objv[i])), GINT_TO_POINTER(val));
        }
        result = sum_tree_int((GTreeInt*)tree);
        g_tree_destroy(tree);
    }
    return result;
}

    %}
