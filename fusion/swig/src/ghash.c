#include <glib.h>
#include <math.h>
#include <string.h>

/* --- String-to-String Hash Functions --- */

char* get_value_str_str(GHashTable *table, const char *key) {
    if (!table || !key) return "NOT_FOUND";
    char* val = (char*)g_hash_table_lookup(table, key);
    return val ? val : "NOT_FOUND";
}


/* --- String-to-Integer Hash Functions --- */

/* Specific accessor for Integer values */
int get_value_str_int(GHashTable *table, const char *key) {
    if (!table || !key) return -1;
    
    gpointer val = g_hash_table_lookup(table, key);
    
    /* Safely check if the key exists before casting */
    if (val == NULL && !g_hash_table_contains(table, key)) {
        return -1; 
    }
    
    /* Use the GLib macro to convert pointer back to int */
    return GPOINTER_TO_INT(val);
}

/* --- String-to-Boolean Hash Functions --- */

int get_value_str_bool(GHashTable *table, const char *key) {
    if (!table || !key) return 0;
    
    gpointer val = g_hash_table_lookup(table, key);
    if (val == NULL && !g_hash_table_contains(table, key)) {
        return 0; // Default to false if key is missing
    }
    
    return GPOINTER_TO_INT(val);
}

/* --- String-to-Float Hash Functions --- */
float get_value_str_float(GHashTable *table, const char *key) {
    if (!table || !key) return 0.0f;
    gpointer val = g_hash_table_lookup(table, key);
    if (val) {
        return *(float*)val; // Dereference the pointer to get the float
    }
    return 0.0f;
}

