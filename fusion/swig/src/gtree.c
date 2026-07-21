#include "gtree.h"
#include <stdio.h>

/* Helper: Callback for summing integer values */
static gboolean sum_nodes(gpointer key, gpointer value, gpointer data) {
    int *total = (int *)data;
    *total += GPOINTER_TO_INT(value);
    return FALSE; /* Continue traversal */
}

int sum_tree_int(GTreeInt *tree) {
    int total = 0;
    if (tree) {
        g_tree_foreach((GTree *)tree, (GTraverseFunc)sum_nodes, &total);
    }
    return total;
}
