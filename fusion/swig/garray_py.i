/* ================================================================= 
   NUMBERS (Integers & Floats)
   ================================================================= */

%typemap(in) GFloatArray * {
    if (!PyList_Check($input)) {
        PyErr_SetString(PyExc_TypeError, "Expected a list of floats");
        return NULL;
    }
    Py_ssize_t size = PyList_Size($input);
    $1 = g_array_new(FALSE, FALSE, sizeof(gfloat));
    for (Py_ssize_t i = 0; i < size; i++) {
        PyObject *o = PyList_GetItem($input, i);
        gfloat val = (gfloat)PyFloat_AsDouble(o);
        if (PyErr_Occurred()) {
            g_array_free($1, TRUE); return NULL;
        }
        g_array_append_val($1, val);
    }
}

%typemap(out) GFloatArray * {
    if ($1 == NULL) {
        $result = PyList_New(0);
    } else {
        $result = PyList_New($1->len);
        for (guint i = 0; i < $1->len; i++) {
            PyList_SetItem($result, i, PyFloat_FromDouble((double)g_array_index($1, gfloat, i)));
        }
        g_array_free($1, TRUE);
    }
}

/* ================================================================= 
   INTEGERS (GIntArray)
   ================================================================= */

%typemap(in) GIntArray * {
    if (!PyList_Check($input)) {
        PyErr_SetString(PyExc_TypeError, "Expected a list of integers");
        return NULL;
    }
    Py_ssize_t size = PyList_Size($input);
    $1 = g_array_new(FALSE, FALSE, sizeof(gint));
    for (Py_ssize_t i = 0; i < size; i++) {
        PyObject *o = PyList_GetItem($input, i);
        /* PyLong_AsLong handles the conversion from Python int to C long */
        long val = PyLong_AsLong(o);
        
        if (PyErr_Occurred()) {
            g_array_free($1, TRUE);
            return NULL;
        }
        gint gval = (gint)val;
        g_array_append_val($1, gval);
    }
}

%typemap(out) GIntArray * {
    if ($1 == NULL) {
        $result = PyList_New(0);
    } else {
        $result = PyList_New($1->len);
        for (guint i = 0; i < $1->len; i++) {
            gint val = g_array_index($1, gint, i);
            /* PyLong_FromLong converts C int/long back to Python int object */
            PyList_SetItem($result, i, PyLong_FromLong((long)val));
        }
        g_array_free($1, TRUE);
    }
}

/* ================================================================= 
   STRINGS
   ================================================================= */

%typemap(in) GStringArray * {
    if (!PyList_Check($input)) {
        PyErr_SetString(PyExc_TypeError, "Expected a list of strings");
        return NULL;
    }
    Py_ssize_t size = PyList_Size($input);
    $1 = g_array_new(FALSE, FALSE, sizeof(char*));
    for (Py_ssize_t i = 0; i < size; i++) {
        PyObject *o = PyList_GetItem($input, i);
        const char *s = PyUnicode_AsUTF8(o);
        if (!s) {
            g_array_free($1, TRUE); return NULL;
        }
        char *s_copy = g_strdup(s);
        g_array_append_val($1, s_copy);
    }
}

%typemap(out) GStringArray * {
    $result = PyList_New($1 ? $1->len : 0);
    if ($1) {
        for (guint i = 0; i < $1->len; i++) {
            char *s = g_array_index($1, char*, i);
            PyList_SetItem($result, i, PyUnicode_FromString(s));
            g_free(s);
        }
        g_array_free($1, TRUE);
    }
}

/* ================================================================= 
   BOOLEANS
   ================================================================= */

%typemap(in) GBoolArray * {
    if (!PyList_Check($input)) {
        PyErr_SetString(PyExc_TypeError, "Expected a list of bools");
        return NULL;
    }
    Py_ssize_t size = PyList_Size($input);
    $1 = g_array_new(FALSE, FALSE, sizeof(gboolean));
    for (Py_ssize_t i = 0; i < size; i++) {
        PyObject *o = PyList_GetItem($input, i);
        gboolean val = PyObject_IsTrue(o) ? TRUE : FALSE;
        g_array_append_val($1, val);
    }
}

%typemap(out) GBoolArray * {
    $result = PyList_New($1 ? $1->len : 0);
    if ($1) {
        for (guint i = 0; i < $1->len; i++) {
            PyObject *b = g_array_index($1, gboolean, i) ? Py_True : Py_False;
            Py_INCREF(b);
            PyList_SetItem($result, i, b);
        }
        g_array_free($1, TRUE);
    }
}

/* Cleanup for Input Arrays */
%typemap(freearg) GFloatArray *, GBoolArray *, GIntArray * {
    if ($1) g_array_free($1, TRUE);
}

%typemap(freearg) GStringArray * {
    if ($1) {
        for (guint i = 0; i < $1->len; i++) g_free(g_array_index($1, char*, i));
        g_array_free($1, TRUE);
    }
}

