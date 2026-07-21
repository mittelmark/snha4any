%module glist_test

%{
#include <glib.h>
#include "../../src/glist_test.h"

/* Typedefs for unique typemap matching */
typedef GList GListStr;
typedef GList GListInt;
%}

typedef GList GListStr;
typedef GList GListInt;

/* ----------------------------------------------------------------
   Include the language-specific typemaps and inline functions
   ---------------------------------------------------------------- */
#ifdef SWIGPYTHON
%include "glist_py.i"
#elif defined(SWIGLUA)
%include "glist_lua.i"
#elif defined(SWIGTCL)
/* Rename the Tcl commands to match the desired API while 
   allowing the wrapper functions to have unique names in C */
%rename(print_list_str)      print_list_str_tcl;
%rename(get_sample_list_str) get_sample_list_str_tcl;
%rename(get_sample_list_int) get_sample_list_int_tcl;
/* Also ensure the production API rename is present if not already handled */
%rename(sum_list_int)        sum_list_int_tcl;
%include "glist_tcl.i"
#endif

/* ----------------------------------------------------------------
   Exported Functions
   ---------------------------------------------------------------- */

/* We hide these declarations from Tcl because glist_tcl.i 
   provides its own stable %inline versions via the %rename path.
   Python and Lua continue to use these standard declarations.
*/
#ifndef SWIGTCL
void      print_list_str(GListStr *list);
GListStr* get_sample_list_str();
GListInt* get_sample_list_int();
#endif
