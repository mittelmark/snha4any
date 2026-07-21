#include <glib.h>
#include <math.h>
#include <string.h>

GHashTable* create_config_hash() {
    /* Keys and Values are both strings, so we use g_free for both */
    GHashTable *table = g_hash_table_new_full(g_str_hash, g_str_equal, g_free, g_free);
    g_hash_table_insert(table, g_strdup("OS"), g_strdup("Linux"));
    g_hash_table_insert(table, g_strdup("Arch"), g_strdup("x86_64"));
    return table;
}

/* Creates a sample string-to-int hash table */
GHashTable* create_int_config() {
    /* Key: string (g_free), Value: int (no free needed) */
    GHashTable *table = g_hash_table_new_full(g_str_hash, g_str_equal, g_free, NULL);
    g_hash_table_insert(table, g_strdup("max_users"), GINT_TO_POINTER(100));
    g_hash_table_insert(table, g_strdup("timeout"), GINT_TO_POINTER(30));
    return table;
}



