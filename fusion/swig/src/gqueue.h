#ifndef GQUEUE_H
#define GQUEUE_H

#include <glib.h>

/* Specialized types for SWIG typemap matching */
typedef GQueue GIntQueue;
typedef GQueue GBoolQueue;
typedef GQueue GFloatQueue;
typedef GQueue GStringQueue;

/* --- Integer Queue --- */
int sum_int_queue(GIntQueue *queue);
GIntQueue* create_int_queue(int n);

/* --- Boolean Queue --- */
int count_true_queue(GBoolQueue *queue);
GBoolQueue* create_bool_queue(int n);

/* --- Float Queue --- */
float sum_float_queue(GFloatQueue *queue);
GFloatQueue* create_float_queue(int n);

/* --- String Queue --- */
int total_length_queue(GStringQueue *queue);
GStringQueue* create_string_queue();

#endif /* GQUEUE_H */
