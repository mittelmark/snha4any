#ifndef GLIST_TEST_H
#define GLIST_TEST_H

#include <glib.h>

typedef GList GListStr;
typedef GList GListInt;

/* --- String List Functions --- */

/**
 * Takes a list of strings from the script and prints them.
 */
void print_list_str(GList *list);

/**
 * Returns a new list of strings to the script.
 */
GList* get_sample_list_str();

/**
 * Returns a list of integers to the script.
 */
GList* get_sample_list_int();

#endif /* GLIST_TEST_H */
