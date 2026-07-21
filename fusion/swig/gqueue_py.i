/* ================================================================= 
   INTEGER QUEUE
   ================================================================= */
%typemap(in) GIntQueue * {
    if (!PyList_Check($input)) {
        PyErr_SetString(PyExc_TypeError, "Expected a list of integers");
        return NULL;
    }
    Py_ssize_t size = PyList_Size($input);
    $1 = g_queue_new();
    for (Py_ssize_t i = 0; i < size; i++) {
        long val = PyLong_AsLong(PyList_GetItem($input, i));
        g_queue_push_tail($1, GINT_TO_POINTER((int)val));
    }
}

%typemap(out) GIntQueue * {
    if (!$1) {
        $result = PyList_New(0);
    } else {
        $result = PyList_New(g_queue_get_length($1));
        int i = 0;
        GList *l;
        for (l = $1->head; l != NULL; l = l->next) {
            PyList_SetItem($result, i++, PyLong_FromLong(GPOINTER_TO_INT(l->data)));
        }
        g_queue_free($1);
    }
}

/* ================================================================= 
   BOOLEAN QUEUE
   ================================================================= */
%typemap(in) GBoolQueue * {
    if (!PyList_Check($input)) {
        PyErr_SetString(PyExc_TypeError, "Expected a list of bools");
        return NULL;
    }
    Py_ssize_t size = PyList_Size($input);
    $1 = g_queue_new();
    for (Py_ssize_t i = 0; i < size; i++) {
        int val = PyObject_IsTrue(PyList_GetItem($input, i));
        g_queue_push_tail($1, GINT_TO_POINTER(val));
    }
}

%typemap(out) GBoolQueue * {
    if (!$1) {
        $result = PyList_New(0);
    } else {
        $result = PyList_New(g_queue_get_length($1));
        int i = 0;
        GList *l;
        for (l = $1->head; l != NULL; l = l->next) {
            PyObject *b = GPOINTER_TO_INT(l->data) ? Py_True : Py_False;
            Py_INCREF(b);
            PyList_SetItem($result, i++, b);
        }
        g_queue_free($1);
    }
}

/* ================================================================= 
   FLOAT QUEUE
   ================================================================= */
%typemap(in) GFloatQueue * {
    if (!PyList_Check($input)) {
        PyErr_SetString(PyExc_TypeError, "Expected a list of floats");
        return NULL;
    }
    Py_ssize_t size = PyList_Size($input);
    $1 = g_queue_new();
    for (Py_ssize_t i = 0; i < size; i++) {
        float *f = g_new(float, 1);
        *f = (float)PyFloat_AsDouble(PyList_GetItem($input, i));
        g_queue_push_tail($1, f);
    }
}

%typemap(out) GFloatQueue * {
    if (!$1) {
        $result = PyList_New(0);
    } else {
        $result = PyList_New(g_queue_get_length($1));
        int i = 0;
        GList *l;
        for (l = $1->head; l != NULL; l = l->next) {
            PyList_SetItem($result, i++, PyFloat_FromDouble((double)*(float*)l->data));
            g_free(l->data);
        }
        g_queue_free($1);
    }
}

/* ================================================================= 
   STRING QUEUE
   ================================================================= */
%typemap(in) GStringQueue * {
    if (!PyList_Check($input)) {
        PyErr_SetString(PyExc_TypeError, "Expected a list of strings");
        return NULL;
    }
    Py_ssize_t size = PyList_Size($input);
    $1 = g_queue_new();
    for (Py_ssize_t i = 0; i < size; i++) {
        PyObject *item = PyList_GetItem($input, i);
        const char *s = PyUnicode_AsUTF8(item);
        g_queue_push_tail($1, g_strdup(s));
    }
}

%typemap(out) GStringQueue * {
    if (!$1) {
        $result = PyList_New(0);
    } else {
        $result = PyList_New(g_queue_get_length($1));
        int i = 0;
        GList *l;
        for (l = $1->head; l != NULL; l = l->next) {
            PyList_SetItem($result, i++, PyUnicode_FromString((char*)l->data));
            g_free(l->data);
        }
        g_queue_free($1);
    }
}

/* Generic Cleanup */
%typemap(freearg) GStringQueue *, GFloatQueue * {
    if ($1) g_queue_free_full($1, g_free);
}
%typemap(freearg) GIntQueue *, GBoolQueue * {
    if ($1) g_queue_free($1);
}
