#include "gtree_test.h"
#include <stdio.h>

/* Helper: Callback for printing tree nodes */
static gboolean print_node(gpointer key, gpointer value, gpointer data) {
    printf("  Key: %s, Value: %s\n", (char *)key, (char *)value);
    return FALSE; /* Continue traversal */
}


void print_tree_str(GTreeStr *tree) {
    if (!tree) {
        printf("Tree is empty or NULL.\n");
        return;
    }
    printf("Printing GTree contents:\n");
    g_tree_foreach((GTree *)tree, (GTraverseFunc)print_node, NULL);
}

GTreeStr* get_sample_tree_str() {
    /* Use g_tree_new to match the g_strcmp0 signature (GCompareFunc).
       This avoids "incompatible pointer type" errors with modern compilers. */
    GTree *tree = g_tree_new((GCompareFunc)g_strcmp0);

    /* Insert sample data */
    g_tree_insert(tree, g_strdup("Language"), g_strdup("C"));
    g_tree_insert(tree, g_strdup("Library"), g_strdup("GLib"));
    g_tree_insert(tree, g_strdup("Status"), g_strdup("Sorted"));

    return (GTreeStr *)tree;
}
