#ifndef GTREE_H
#define GTREE_H

#include <glib.h>

/* --- Typedefs for SWIG Typemap Matching --- */
/* These allow us to use the same underlying GTree structure 
   but apply different language-level conversions (e.g., strings vs ints). */
typedef GTree GTreeStr;
typedef GTree GTreeInt;

/**
 * Calculates the sum of all integer values in the tree.
 * @param tree A GTree where values were stored using GINT_TO_POINTER.
 */
int sum_tree_int(GTreeInt *tree);

/* Helper: Callback for summing integer values */
static gboolean sum_nodes(gpointer key, gpointer value, gpointer data);

#endif /* GTREE_H */
