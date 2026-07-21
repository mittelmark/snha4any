%module mglib

%module mglib

%{
#include <glib.h>
#include "../../src/ghash.h"   
#include "../../src/garray.h"
#include "../../src/glist.h"
#include "../../src/gtree.h"
#include "../../src/gqueue.h"
/* Language-specific C headers */
#if defined(SWIGTCL)
    #include <tcl.h>
    /* Compatibility Macro for Tcl 8 vs Tcl 9 */
    #ifndef TCL_SIZE_MAX
        /* If Tcl_Size is not defined by the headers (Tcl < 9) */
        typedef int Tcl_Size;
    #endif
#elif defined(SWIGPYTHON)
   #define PY_SSIZE_T_CLEAN
   #include <Python.h>
#elif defined(SWIGLUA)
   /* --- Lua 5.1 vs 5.4 Compatibility Bridge --- */
   #if LUA_VERSION_NUM >= 502
       /* Lua 5.2+ renamed lua_objlen to lua_rawlen */
       #define lua_objlen lua_rawlen
       #include <lua.h>
       #include <lauxlib.h>
       #include <lualib.h>
    #endif
#endif
#ifndef MGLIB_RELEASE
#include "../../src/glist_test.h"
#include "../../src/gtree_test.h"
#endif    
%}

#ifndef MGLIB_RELEASE
    %include "glist_test.i"
    %include "gtree_test.i"
#endif

/* Import the individual module definitions */
%include "ghash.i"
%include "garray.i"
%include "glist.i"
%include "gtree.i"
%include "gqueue.i"
