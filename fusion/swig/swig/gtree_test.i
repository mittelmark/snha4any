%module gtree_test

%{
#include "../../src/gtree_test.h"
/* Typedefs for unique typemap matching */
typedef GTree GTreeStr;
typedef GTree GTreeInt;


%}

/* ----------------------------------------------------------------
   Tcl Renames for Test Functions
   ---------------------------------------------------------------- */
#ifdef SWIGPYTHON
%include "gtree_py.i"
#elif defined(SWIGLUA)
%include "gtree_lua.i"
#elif defined(SWIGTCL)
%rename(print_tree_str)      print_tree_str_tcl;
%rename(get_sample_tree_str) get_sample_tree_str_tcl;
%rename(sum_tree_int)        sum_tree_int_tcl;
%include "gtree_tcl.i"
#endif

/* ----------------------------------------------------------------
   Declarations
   ---------------------------------------------------------------- */

/* Only wrap these if not in Tcl mode, or if Tcl uses the bridge.
   Since gtree_tcl.i provides %inline versions, we use the same 
   guard pattern as the main interface.
*/
#ifndef SWIGTCL
void      print_tree_str(GTreeStr *tree);
GTreeStr* get_sample_tree_str();
#endif
