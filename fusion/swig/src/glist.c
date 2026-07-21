#include <glib.h>
#include <stdio.h>


/* --- Integer List Functions --- */

/**
 * Sums a list of integers passed from the script.
 */
int sum_list_int(GList *list) {
    int sum = 0;
    for (GList *l = list; l != NULL; l = l->next) {
        sum += GPOINTER_TO_INT(l->data);
    }
    return sum;
}

