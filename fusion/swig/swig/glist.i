%module glist

%{
#include <glib.h>

/* Typedefs for unique typemap matching */
typedef GList GListStr;
typedef GList GListInt;
%}

/* Tell SWIG about the custom types for typemap matching */
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
int       sum_list_int(GListInt *list);
#endif
