%module gtree

%{
#include <glib.h>
#include "../../src/gtree.h"

/* Typedefs for unique typemap matching */
typedef GTree GTreeStr;
typedef GTree GTreeInt;

/* Comparison function for string keys */
static gint compare_strings(gconstpointer a, gconstpointer b) {
    return g_strcmp0((const char *)a, (const char *)b);
}
%}

/* Tell SWIG about the custom types */
typedef GTree GTreeStr;
typedef GTree GTreeInt;

/* ----------------------------------------------------------------
   Include language-specific typemaps
   ---------------------------------------------------------------- */
#ifdef SWIGPYTHON
%include "gtree_py.i"
#elif defined(SWIGLUA)
%include "gtree_lua.i"
#elif defined(SWIGTCL)
/* Rename for Tcl stable bridge naming convention */
%rename(sum_tree_int)        sum_tree_int_tcl;

%include "gtree_tcl.i"
#endif

/* ----------------------------------------------------------------
   Exported Functions
   ---------------------------------------------------------------- */
#ifndef SWIGTCL
int       sum_tree_int(GTreeInt *tree);
#endif
