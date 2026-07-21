%module ghash

%{
#include <glib.h>

/* Typedefs for unique typemap matching */
typedef GHashTable GHashStrStr;
typedef GHashTable GHashStrInt;
typedef GHashTable GHashStrBool;
typedef GHashTable GHashStrFloat;
    
/* Prototypes with specific naming for each type */
extern char* get_value_str_str(GHashStrStr *table, const char *key);
extern int get_value_str_int(GHashStrStr *table, const char *key);    
extern int get_value_str_bool(GHashStrBool *table, const char *key);    
extern float get_value_str_float(GHashStrFloat *table, const char *key);
#ifdef MGLIB_RELEASE    
extern GHashStrStr* create_config_hash();
#endif
%}

/* Tell SWIG about the custom types */
typedef GHashTable GHashStrStr;
typedef GHashTable GHashStrInt;
typedef GHashTable GHashStrBool;
typedef GHashTable GHashStrFloat;

/* ----------------------------------------------------------------
   Include the language-specific typemaps and inline functions
   ---------------------------------------------------------------- */
#ifdef SWIGTCL
%include "ghash_tcl.i"
#endif

#ifdef SWIGPYTHON
%include "ghash_py.i"
#endif

#ifdef SWIGLUA
%include "ghash_lua.i"
#endif

/* --- Exported Functions --- */
//int count_keys(GHashTable *table);
char* get_value_str_str(GHashStrStr *table, const char *key);
int   get_value_str_int(GHashStrInt *table, const char *key);
int get_value_str_bool(GHashStrBool *table, const char *key);
float get_value_str_float(GHashStrFloat *table, const char *key);
#ifdef MGLIB_RELEASE
GHashStrStr* create_config_hash();
#endif
