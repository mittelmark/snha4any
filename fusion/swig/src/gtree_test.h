#ifndef GTREE_TEST_H
#define GTREE_TEST_H

#include <glib.h>

typedef GTree GTreeStr;
typedef GTree GTreeInt;

/**
 * Prints all key-value pairs in a tree where both are strings.
 * @param tree A GTree containing gchar* keys and values.
 */
void print_tree_str(GTreeStr *tree);

/* Helper: Callback for printing tree nodes */
static gboolean print_node(gpointer key, gpointer value, gpointer data);

/**
 * Returns a sample GTree populated with hardcoded string data.
 * The tree is configured to automatically free its memory.
 */
GTreeStr* get_sample_tree_str();

#endif /* GTREE_TEST_H */

