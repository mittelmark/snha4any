#include <glib.h>
#include <stdio.h>
#include "glist_test.h"
/* --- String List Functions --- */

/**
 * Takes a list of strings from the script and prints them.
 * The 'in' typemap handles the conversion from Script List to GList*.
 */
void print_list_str(GList *list) {
    printf("Debug: Received GList at %p\n", (void*)list);
    if (!list) {
        printf("Debug: List is NULL\n");
        return;
    }
    for (GList *l = list; l != NULL; l = l->next) {
        printf("Debug: Node %p, Data: %s\n", (void*)l, (char*)l->data);
    }
}

/**
 * Returns a new list of strings to the script.
 * The 'out' typemap will convert this GList* back to a native Script List.
 */
GList* get_sample_list_str() {
    GList *list = NULL;
    list = g_list_append(list, g_strdup("Alpha"));
    list = g_list_append(list, g_strdup("Bravo"));
    list = g_list_append(list, g_strdup("Charlie"));
    return list;
}


/**
 * Returns a list of integers to the script.
 */
GList* get_sample_list_int() {
    GList *list = NULL;
    list = g_list_append(list, GINT_TO_POINTER(10));
    list = g_list_append(list, GINT_TO_POINTER(20));
    list = g_list_append(list, GINT_TO_POINTER(30));
    return list;
}
