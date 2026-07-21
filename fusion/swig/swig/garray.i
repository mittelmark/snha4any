%module garray

%{
#include <glib.h>
#include <math.h>

/* Typedefs to allow distinct typemaps for the same underlying C struct */
typedef GArray GIntArray;
typedef GArray GFloatArray;
typedef GArray GStringArray;
typedef GArray GBoolArray;

/* Prototypes for the C compiler */
extern float sum_float_array(GFloatArray *garray);
extern int sum_int_array(GIntArray *garray);
extern GFloatArray* create_float_array(int size);
extern GIntArray* create_int_array(int size);
extern int sum_string_lengths(GStringArray *garray);
extern GStringArray* create_string_array();
extern int count_true_values(GBoolArray *garray);
extern GBoolArray* create_bool_array(int size);

%}

/* Tell SWIG about the type names */
typedef GArray GIntArray;
typedef GArray GFloatArray;
typedef GArray GStringArray;
typedef GArray GBoolArray;

/* ----------------------------------------------------------------
   Include the language-specific typemaps and inline functions
   ---------------------------------------------------------------- */
#ifdef SWIGTCL
%include "garray_tcl.i"
#endif

#ifdef SWIGPYTHON
%include "garray_py.i"
#endif

#ifdef SWIGLUA
%include "garray_lua.i"
#endif

/* Functions for SWIG to wrap */
float sum_float_array(GFloatArray *garray);
int sum_int_array(GIntArray *garray);
GFloatArray* create_float_array(int size);
GIntArray* create_int_array(int size);
int sum_string_lengths(GStringArray *garray);
GStringArray* create_string_array();
int count_true_values(GBoolArray *garray);
GBoolArray* create_bool_array(int size);
