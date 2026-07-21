#include <glib.h>
#include <math.h>
#include <string.h>

/* ================================================================= 
   FLOAT FUNCTIONS
   ================================================================= */

/**
 * Iterates through a GArray of gfloats and returns the sum.
 */
float sum_float_array(GArray *garray) {
    if (garray == NULL || garray->len == 0) {
        return 0.0f;
    }
    
    float sum = 0.0f;
    for (guint i = 0; i < garray->len; i++) {
        gfloat val = g_array_index(garray, gfloat, i);
        /* Standard C isnan() works on gfloat/float */
        if (!isnan(val)) {
            sum += val;
        }
    }
    return sum;
}

/**
 * Allocates a new GArray and fills it with sample float data.
 */
GArray* create_float_array(int size) {
    if (size < 0) return NULL;
    
    GArray *garray = g_array_new(FALSE, FALSE, sizeof(gfloat));
    for (int i = 0; i < size; i++) {
        gfloat val = (gfloat)i + 0.5f;
        g_array_append_val(garray, val);
    }
    return garray;
}

/* ================================================================= 
   INTEGER FUNCTIONS
   ================================================================= */

/**
 * Iterates through a GArray of gints and returns the sum.
 */
int sum_int_array(GArray *garray) {
    if (garray == NULL || garray->len == 0) {
        return 0;
    }
    
    int sum = 0;
    for (guint i = 0; i < garray->len; i++) {
        gint val = g_array_index(garray, gint, i);
        sum += val;
    }
    return sum;
}

/**
 * Allocates a new GArray and fills it with sample integer data.
 */
GArray* create_int_array(int size) {
    if (size < 0) return NULL;

    GArray *garray = g_array_new(FALSE, FALSE, sizeof(gint));
    for (int i = 0; i < size; i++) {
        gint val = i * 10;
        g_array_append_val(garray, val);
    }
    return garray;
}


/* --- STRING FUNCTIONS --- */
int sum_string_lengths(GArray *garray) {
    if (!garray) return 0;
    int total = 0;
    for (guint i = 0; i < garray->len; i++) {
        char* s = g_array_index(garray, char*, i);
        if (s) total += strlen(s);
    }
    return total;
}

GArray* create_string_array() {
    GArray *garray = g_array_new(FALSE, FALSE, sizeof(char*));
    char* vals[] = {"Tcl", "is", "Powerful"};
    for (int i = 0; i < 3; i++) {
        char* s = g_strdup(vals[i]);
        g_array_append_val(garray, s);
    }
    return garray;
}

/* --- BOOLEAN FUNCTIONS --- */
int count_true_values(GArray *garray) {
    if (!garray) return 0;
    int count = 0;
    for (guint i = 0; i < garray->len; i++) {
        if (g_array_index(garray, gboolean, i)) count++;
    }
    return count;
}

GArray* create_bool_array(int size) {
    GArray *garray = g_array_new(FALSE, FALSE, sizeof(gboolean));
    for (int i = 0; i < size; i++) {
        gboolean val = (i % 2 == 0);
        g_array_append_val(garray, val);
    }
    return garray;
}

