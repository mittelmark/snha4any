/* Typemap: GListStr (Python List -> GList of Strings) */
%typemap(in) GListStr * {
    if (!PyList_Check($input)) {
        PyErr_SetString(PyExc_TypeError, "Expected a list of strings");
        return NULL;
    }
    $1 = NULL;
    Py_ssize_t size = PyList_Size($input);
    for (Py_ssize_t i = 0; i < size; i++) {
        PyObject *item = PyList_GetItem($input, i);
        $1 = g_list_append($1, g_strdup(PyUnicode_AsUTF8(item)));
    }
}

/* Cleanup memory after function call */
%typemap(freearg) GListStr * {
    if ($1) {
        g_list_free_full($1, g_free);
    }
}

/* Typemap: GListInt (Python List -> GList of Integers) */
%typemap(in) GListInt * {
    if (!PyList_Check($input)) {
        PyErr_SetString(PyExc_TypeError, "Expected a list of integers");
        return NULL;
    }
    $1 = NULL;
    Py_ssize_t size = PyList_Size($input);
    for (Py_ssize_t i = 0; i < size; i++) {
        PyObject *item = PyList_GetItem($input, i);
        $1 = g_list_append($1, GINT_TO_POINTER((int)PyLong_AsLong(item)));
    }
}

%typemap(freearg) GListInt * {
    if ($1) g_list_free($1);
}

/* Typemap: GListStr -> Python List */
%typemap(out) GListStr * {
    PyObject *py_list = PyList_New(g_list_length($1));
    GList *l;
    int i = 0;
    for (l = $1; l != NULL; l = l->next) {
        PyList_SetItem(py_list, i++, PyUnicode_FromString((char*)l->data));
    }
    $result = py_list;
    if ($1) g_list_free_full($1, g_free);
}

/* Typemap: GListInt -> Python List */
%typemap(out) GListInt * {
    PyObject *py_list = PyList_New(g_list_length($1));
    GList *l;
    int i = 0;
    for (l = $1; l != NULL; l = l->next) {
        PyList_SetItem(py_list, i++, PyLong_FromLong((long)GPOINTER_TO_INT(l->data)));
    }
    $result = py_list;
    if ($1) g_list_free($1);
}
