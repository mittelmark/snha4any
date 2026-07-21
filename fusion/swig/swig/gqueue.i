%module gqueue

%{
#include <glib.h>
#include "../../src/gqueue.h"

/* Typedefs for typemap matching */
typedef GQueue GIntQueue;
typedef GQueue GBoolQueue;
typedef GQueue GFloatQueue;
typedef GQueue GStringQueue;
#ifndef MGLIB_RELEASE
/* Inline helper to create a sample integer queue for testing purposes.
 This is only available in debug/non-release builds.
*/
    
GIntQueue* get_sample_int_queue() {
    GQueue *q = g_queue_new();
    /* Argument 1 is now a pointer, matching the function signature */
    g_queue_push_tail(q, GINT_TO_POINTER(100));
    g_queue_push_tail(q, GINT_TO_POINTER(200));
    g_queue_push_tail(q, GINT_TO_POINTER(300));        
    return (GIntQueue*)q;
}
/**
Calculates the total length of all strings in a queue.
When called from Lua with a table, the GStringQueue* typemap
handles the conversion and memory management.
*/
int sum_string_queue_lengths(GStringQueue *queue) {
    if (!queue) return 0;
    int total = 0;
    GList *l;
    for (l = queue->head; l != NULL; l = l->next) {
        char *s = (char *)l->data;
        if (s) {
            total += strlen(s);
        }
    }
    return total;
}
/**
Returns a queue of sample strings.
SWIG's 'out' typemap for GStringQueue* will convert this
into a Lua table and free the C memory automatically.
*/
GStringQueue* get_sample_str_queue() {
    GQueue *q = g_queue_new();
    g_queue_push_tail(q, g_strdup("Lua"));
    g_queue_push_tail(q, g_strdup("is"));
    g_queue_push_tail(q, g_strdup("fast"));
    return (GStringQueue*)q;
}    
#endif
    
%}

/* Tell SWIG about specialized types */
typedef GQueue GIntQueue;
typedef GQueue GBoolQueue;
typedef GQueue GFloatQueue;
typedef GQueue GStringQueue;

#ifdef SWIGTCL
// Rename the script-level command to the original name,
// while the bridge function in C has the _tcl suffix.
%rename(sum_int_queue)       sum_int_queue_tcl;
%rename(create_int_queue)    create_int_queue_tcl;
%rename(total_length_queue)  total_length_queue_tcl;
%rename(create_string_queue) create_string_queue_tcl;
%rename(get_sample_int_queue) get_sample_int_queue_tcl;
%rename(get_sample_str_queue) get_sample_str_queue_tcl;

/* New Renames for Bool and Float */
%rename(count_true_queue)     count_true_queue_tcl;
%rename(create_bool_queue)    create_bool_queue_tcl;
%rename(sum_float_queue)      sum_float_queue_tcl;
%rename(create_float_queue)   create_float_queue_tcl;
%include "gqueue_tcl.i"
#endif

#ifdef SWIGPYTHON
%include "gqueue_py.i"
#endif

#ifdef SWIGLUA
%include "gqueue_lua.i"
#endif

/* ----------------------------------------------------------------
Standard Exported Functions
   ---------------------------------------------------------------- */
#ifndef SWIGTCL

int sum_int_queue(GIntQueue *queue);
GIntQueue* create_int_queue(int n);

int count_true_queue(GBoolQueue *queue);
GBoolQueue* create_bool_queue(int n);

float sum_float_queue(GFloatQueue *queue);
GFloatQueue* create_float_queue(int n);

int total_length_queue(GStringQueue *queue);
GStringQueue* create_string_queue();
#ifndef MGLIB_RELEASE
GIntQueue* get_sample_int_queue();
GStringQueue* get_sample_str_queue();
int sum_string_queue_lengths(GStringQueue *queue);
#endif
#endif
