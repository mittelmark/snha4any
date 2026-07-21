%module miniglist

%{
#include <glib.h>
#include <tcl.h>

/* Compatibility for Tcl 8/9 */
#ifndef TCL_SIZE_MAX
    typedef int Tcl_Size;
#endif

/* --- Internal C Implementations --- */

/* Integer List Logic */
static int sum_list_test_internal(void **items, Tcl_Size count) {
    int sum = 0;
    GList *list = NULL;
    Tcl_Size i;
    
    for (i = 0; i < count; i++) {
        list = g_list_append(list, items[i]);
    }

    GList *l;
    for (l = list; l != NULL; l = l->next) {
        sum += GPOINTER_TO_INT(l->data);
    }

    if (list) g_list_free(list);
    return sum;
}

/* String List Logic */
static char* join_strings_test_internal(void **items, Tcl_Size count) {
    GList *list = NULL;
    Tcl_Size i;
    GString *res = g_string_new("");
    
    /* Build GList with strduped copies */
    for (i = 0; i < count; i++) {
        list = g_list_append(list, g_strdup((char*)items[i]));
    }

    /* Join strings with a space */
    GList *l;
    for (l = list; l != NULL; l = l->next) {
        g_string_append(res, (char*)l->data);
        if (l->next) g_string_append(res, " ");
    }

    char *result_str = g_strdup(res->str);
    g_string_free(res, TRUE);
    
    /* Cleanup: Must use g_list_free_full for strduped data */
    if (list) g_list_free_full(list, (GDestroyNotify)g_free);
    
    return result_str;
}
%}

/* --- The Tcl-Facing Wrappers --- */

%inline %{
/* Integer implementation */
int sum_list_test(Tcl_Obj *list_obj) {
    Tcl_Size objc = 0;
    Tcl_Obj **objv = NULL;
    void **items = NULL;
    int result = 0;
    Tcl_Size i;

    if (Tcl_ListObjGetElements(NULL, list_obj, &objc, &objv) != TCL_OK) return 0;
    
    if (objc > 0 && objv != NULL) {
        items = (void **)malloc(sizeof(void *) * objc);
        for (i = 0; i < objc; i++) {
            int val;
            Tcl_GetIntFromObj(NULL, objv[i], &val);
            items[i] = GINT_TO_POINTER(val);
        }
    }
    
    result = sum_list_test_internal(items, objc);
    if (items) free(items);
    return result;
}

/* String implementation */
char* join_strings_test(Tcl_Obj *list_obj) {
    Tcl_Size objc = 0;
    Tcl_Obj **objv = NULL;
    void **items = NULL;
    char *result = NULL;
    Tcl_Size i;

    if (Tcl_ListObjGetElements(NULL, list_obj, &objc, &objv) != TCL_OK) return NULL;
    
    if (objc > 0 && objv != NULL) {
        items = (void **)malloc(sizeof(void *) * objc);
        for (i = 0; i < objc; i++) {
            /* We store the raw pointer from Tcl temporarily; 
               internal function will g_strdup it */
            items[i] = (void *)Tcl_GetString(objv[i]);
        }
    }
    
    result = join_strings_test_internal(items, objc);
    if (items) free(items);
    
    /* SWIG will handle the return char* by creating a new Tcl String Obj */
    return result;
}
    %}
