#ifndef GHASH_H
#define GHASH_H

#include <glib.h>

/* Typedefs for unique typemap matching in the C compiler */
typedef GHashTable GHashStrStr;
typedef GHashTable GHashStrInt;
typedef GHashTable GHashStrBool;
typedef GHashTable GHashStrFloat;

/* --- String-to-String Hash Functions --- */
/**
 * Retrieves a string value from a string-keyed hash table.
 */
char* get_value_str_str(GHashStrStr *table, const char *key);

/**
 * Creates a sample string-to-string hash table for testing.
 */
GHashStrStr* create_config_hash();

/* --- String-to-Integer Hash Functions --- */
/**
 * Retrieves an integer value from a string-keyed hash table.
 */
int get_value_str_int(GHashStrInt *table, const char *key);

/**
 * Creates a sample string-to-int hash table for testing.
 */
GHashTable* create_int_config();

/* --- String-to-Boolean Hash Functions --- */
/**
 * Retrieves a boolean (0 or 1) value from a string-keyed hash table.
 */
int get_value_str_bool(GHashStrBool *table, const char *key);

/* --- String-to-Float Hash Functions --- */
/**
 * Retrieves a float value from a string-keyed hash table.
 */
float get_value_str_float(GHashStrFloat *table, const char *key);

#endif /* GHASH_H */
