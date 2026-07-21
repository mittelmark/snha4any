%{
#include <glib.h>
#include <tcl.h>
#include "../../src/gqueue.h"

/* --- Internal Helper: Tcl List -> GQueue of integers --- */
static GQueue* tcl_to_gqueue_int(Tcl_Obj *list_obj) {
    Tcl_Size objc = 0;
    Tcl_Obj **objv = NULL;
    if (Tcl_ListObjGetElements(NULL, list_obj, &objc, &objv) != TCL_OK) return NULL;

    GQueue *q = g_queue_new();
    for (Tcl_Size i = 0; i < objc; i++) {
        int val;
        if (Tcl_GetIntFromObj(NULL, objv[i], &val) == TCL_OK) {
            g_queue_push_tail(q, GINT_TO_POINTER(val));
        }
    }
    return q;
}

/* --- Internal Helper: Tcl List -> GQueue of strings (strduped) --- */
static GQueue* tcl_to_gqueue_str(Tcl_Obj *list_obj) {
    Tcl_Size objc = 0;
    Tcl_Obj **objv = NULL;
    if (Tcl_ListObjGetElements(NULL, list_obj, &objc, &objv) != TCL_OK) return NULL; 

    GQueue *q = g_queue_new();
    for (Tcl_Size i = 0; i < objc; i++) {
        char *str = Tcl_GetString(objv[i]);
        if (str) {
            g_queue_push_tail(q, g_strdup(str));
        }
    }
    return q;
}

/* --- Internal Helper: GQueue of integers -> Tcl List --- */
static Tcl_Obj* gqueue_to_tcl_int(GQueue *q) {
    Tcl_Obj *listPtr = Tcl_NewListObj(0, NULL); 
    if (q) {
        GList *l;
        for (l = q->head; l != NULL; l = l->next) {
            Tcl_ListObjAppendElement(NULL, listPtr, Tcl_NewIntObj(GPOINTER_TO_INT(l->data))); 
        }
    }
    return listPtr;
}

/* --- Internal Helper: GQueue of strings -> Tcl List --- */
static Tcl_Obj* gqueue_to_tcl_str(GQueue *q) {
    Tcl_Obj *listPtr = Tcl_NewListObj(0, NULL); 
    if (q) {
        GList *l;
        for (l = q->head; l != NULL; l = l->next) {
            Tcl_ListObjAppendElement(NULL, listPtr, Tcl_NewStringObj((char*)l->data, -1)); 
        }
    }
    return listPtr;
}
static Tcl_Obj* gqueue_to_tcl_bool(GQueue *q) {
    Tcl_Obj *listPtr = Tcl_NewListObj(0, NULL);
    if (q) {
        GList *l;
        for (l = q->head; l != NULL; l = l->next) {
            Tcl_ListObjAppendElement(NULL, listPtr, Tcl_NewBooleanObj(GPOINTER_TO_INT(l->data)));
        }
    }
    return listPtr;
}

static Tcl_Obj* gqueue_to_tcl_float(GQueue *q) {
    Tcl_Obj *listPtr = Tcl_NewListObj(0, NULL);
    if (q) {
        GList *l;
        for (l = q->head; l != NULL; l = l->next) {
            Tcl_ListObjAppendElement(NULL, listPtr, Tcl_NewDoubleObj((double)*(float*)l->data));
        }
    }
    return listPtr;
}
/* --- Internal Helpers: Tcl List -> GQueue --- */

static GQueue* tcl_to_gqueue_bool(Tcl_Obj *list_obj) {
    Tcl_Size objc = 0; Tcl_Obj **objv = NULL;
    if (Tcl_ListObjGetElements(NULL, list_obj, &objc, &objv) != TCL_OK) return NULL;
    GQueue *q = g_queue_new();
    for (Tcl_Size i = 0; i < objc; i++) {
        int val;
        if (Tcl_GetBooleanFromObj(NULL, objv[i], &val) == TCL_OK) { 
            g_queue_push_tail(q, GINT_TO_POINTER(val));
        }
    }
    return q;
}

static GQueue* tcl_to_gqueue_float(Tcl_Obj *list_obj) {
    Tcl_Size objc = 0; Tcl_Obj **objv = NULL;
    if (Tcl_ListObjGetElements(NULL, list_obj, &objc, &objv) != TCL_OK) return NULL;
    GQueue *q = g_queue_new(); 
    for (Tcl_Size i = 0; i < objc; i++) {
        double val;
        if (Tcl_GetDoubleFromObj(NULL, objv[i], &val) == TCL_OK) {
            float *f = g_new(float, 1); 
            *f = (float)val;
            g_queue_push_tail(q, f); 
        }
    }
    return q;
}    
%}

/* --- Tcl Inline Bridge Functions --- */
%inline %{

int sum_int_queue_tcl(Tcl_Obj *list_obj) {
    GQueue *q = tcl_to_gqueue_int(list_obj);
    int result = 0;
    if (q) {
        result = sum_int_queue((GIntQueue*)q);
        g_queue_free(q);
    }
    return result;
}

Tcl_Obj* create_int_queue_tcl(int n) {
    GIntQueue *q = create_int_queue(n);
    Tcl_Obj *res = gqueue_to_tcl_int((GQueue*)q);
    if (q) g_queue_free((GQueue*)q);
    return res;
}

int total_length_queue_tcl(Tcl_Obj *list_obj) {
    GQueue *q = tcl_to_gqueue_str(list_obj);
    int result = 0;
    if (q) {
        result = total_length_queue((GStringQueue*)q);
        g_queue_free_full(q, g_free); 
    }
    return result;
}

Tcl_Obj* create_string_queue_tcl() {
    GStringQueue *q = create_string_queue();
    Tcl_Obj *res = gqueue_to_tcl_str((GQueue*)q);
    if (q) g_queue_free_full((GQueue*)q, g_free);
    return res;
}
    
Tcl_Obj* get_sample_int_queue_tcl() {
    // Call the original C helper from gqueue.i
    GIntQueue *q = get_sample_int_queue();
    Tcl_Obj *res = gqueue_to_tcl_int((GQueue*)q);
    // Free the temporary queue nodes, as the data is now in Tcl
    if (q) g_queue_free((GQueue*)q); 
    return res;
}

Tcl_Obj* get_sample_str_queue_tcl() {
    // Call the original C helper from gqueue.i
    GStringQueue *q = get_sample_str_queue();
    Tcl_Obj *res = gqueue_to_tcl_str((GQueue*)q);
    // Free the temporary queue and the strduped strings
    if (q) g_queue_free_full((GQueue*)q, g_free);
    return res;
}    
/* --- Boolean Bridge Functions --- */

int count_true_queue_tcl(Tcl_Obj *list_obj) {
    GQueue *q = tcl_to_gqueue_bool(list_obj);
    int result = 0;
    if (q) {
        result = count_true_queue((GBoolQueue*)q);
        g_queue_free(q); // Data is GINT_TO_POINTER, no deep free needed
    }
    return result;
}

Tcl_Obj* create_bool_queue_tcl(int n) {
    GBoolQueue *q = create_bool_queue(n);
    Tcl_Obj *res = gqueue_to_tcl_bool((GQueue*)q);
    if (q) g_queue_free((GQueue*)q);
    return res;
}

/* --- Float Bridge Functions --- */

float sum_float_queue_tcl(Tcl_Obj *list_obj) {
    GQueue *q = tcl_to_gqueue_float(list_obj);
    float result = 0.0f;
    if (q) {
        result = sum_float_queue((GFloatQueue*)q);
        g_queue_free_full(q, g_free); // Must free allocated float pointers 
    }
    return result;
}

Tcl_Obj* create_float_queue_tcl(int n) {
    GFloatQueue *q = create_float_queue(n);
    Tcl_Obj *res = gqueue_to_tcl_float((GQueue*)q);
    if (q) g_queue_free_full((GQueue*)q, g_free); // Deep free C memory
    return res;
}    
%}
