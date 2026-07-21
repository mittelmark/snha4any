#ifndef GARRAY_H
#define GARRAY_H

#include <glib.h>

/* Typedefs for the C compiler to recognize specialized array types */
typedef GArray GIntArray;
typedef GArray GFloatArray;
typedef GArray GStringArray;
typedef GArray GBoolArray;

/* Prototypes for GArray logic */
float sum_float_array(GFloatArray *garray); 
int sum_int_array(GIntArray *garray); 
GFloatArray* create_float_array(int size);
GIntArray* create_int_array(int size);
int sum_string_lengths(GStringArray *garray);
GStringArray* create_string_array();
int count_true_values(GBoolArray *garray);
GBoolArray* create_bool_array(int size);

#endif /* GARRAY_H */
