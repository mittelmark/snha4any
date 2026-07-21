#include <stdio.h>
#include <string.h>
#include "gqueue.h"

/* --- Integer Queue --- */
int sum_int_queue(GIntQueue *queue) {
    if (!queue) return 0;
    int sum = 0;
    GList *l;
    for (l = queue->head; l != NULL; l = l->next) {
        sum += GPOINTER_TO_INT(l->data);
    }
    return sum;
}

GIntQueue* create_int_queue(int n) {
    GQueue *q = g_queue_new();
    for (int i = 1; i <= n; i++) {
        g_queue_push_tail(q, GINT_TO_POINTER(i * 5));
    }
    return q;
}

/* --- Boolean Queue --- */
int count_true_queue(GBoolQueue *queue) {
    if (!queue) return 0;
    int count = 0;
    GList *l;
    for (l = queue->head; l != NULL; l = l->next) {
        if (GPOINTER_TO_INT(l->data)) count++;
    }
    return count;
}

GBoolQueue* create_bool_queue(int n) {
    GQueue *q = g_queue_new();
    for (int i = 0; i < n; i++) {
        g_queue_push_tail(q, GINT_TO_POINTER(i % 2 == 0));
    }
    return q;
}

/* --- Float Queue --- */
float sum_float_queue(GFloatQueue *queue) {
    if (!queue) return 0.0f;
    float sum = 0.0f;
    GList *l;
    for (l = queue->head; l != NULL; l = l->next) {
        /* Floats are often stored as allocated pointers in GQueues to avoid precision loss 
           if the pointer size is smaller than float (though usually they match) */
        sum += *(float*)(l->data);
    }
    return sum;
}

GFloatQueue* create_float_queue(int n) {
    GQueue *q = g_queue_new();
    for (int i = 0; i < n; i++) {
        float *f = g_new(float, 1);
        *f = (float)i * 1.1f;
        g_queue_push_tail(q, f);
    }
    return q;
}

/* --- String Queue --- */
int total_length_queue(GStringQueue *queue) {
    if (!queue) return 0;
    int total = 0;
    GList *l;
    for (l = queue->head; l != NULL; l = l->next) {
        if (l->data) total += strlen((char*)l->data);
    }
    return total;
}

GStringQueue* create_string_queue() {
    GQueue *q = g_queue_new();
    g_queue_push_tail(q, g_strdup("GQueue"));
    g_queue_push_tail(q, g_strdup("is"));
    g_queue_push_tail(q, g_strdup("Fast"));
    return q;
}
