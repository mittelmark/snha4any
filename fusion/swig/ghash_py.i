
/* 1. Python-specific Generic Count */
%inline %{
int count_keys(PyObject *dict_obj) {
    if (PyDict_Check(dict_obj)) return (int)PyDict_Size(dict_obj);
    return 0;
}
%}

/* 2. Typemap: StrStr (Python Dict -> GHashStrStr) */
%typemap(in) GHashStrStr * {
    if (!PyDict_Check($input)) {
        PyErr_SetString(PyExc_TypeError, "Expected a dictionary");
        return NULL;
    }
    $1 = g_hash_table_new_full(g_str_hash, g_str_equal, g_free, g_free);
    PyObject *key, *value;
    Py_ssize_t pos = 0;
    while (PyDict_Next($input, &pos, &key, &value)) {
        g_hash_table_insert($1, g_strdup(PyUnicode_AsUTF8(key)), g_strdup(PyUnicode_AsUTF8(value)));
    }
}
%typemap(freearg) GHashStrStr * { if ($1) g_hash_table_destroy($1); }

/* 3. Typemap: StrInt (Python Dict -> GHashStrInt) */
%typemap(in) GHashStrInt * {
    if (!PyDict_Check($input)) {
        PyErr_SetString(PyExc_TypeError, "Expected a dictionary");
        return NULL;
    }
    $1 = g_hash_table_new_full(g_str_hash, g_str_equal, g_free, NULL);
    PyObject *key, *value;
    Py_ssize_t pos = 0;
    while (PyDict_Next($input, &pos, &key, &value)) {
        g_hash_table_insert($1, g_strdup(PyUnicode_AsUTF8(key)), GINT_TO_POINTER((int)PyLong_AsLong(value)));
    }
}
%typemap(freearg) GHashStrInt * { if ($1) g_hash_table_destroy($1); }

/* GHashStrStr -> Python Dict */
%typemap(out) GHashStrStr * {
    PyObject *dict = PyDict_New();
    if ($1) {
        GHashTableIter iter; gpointer key, value;
        g_hash_table_iter_init(&iter, $1);
        while (g_hash_table_iter_next(&iter, &key, &value)) {
            PyDict_SetItemString(dict, (char*)key, PyUnicode_FromString((char*)value));
        }
        g_hash_table_destroy($1);
    }
    $result = dict;
}

/* GHashStrInt -> Python Dict */
%typemap(out) GHashStrInt * {
    PyObject *dict = PyDict_New();
    if ($1) {
        GHashTableIter iter; gpointer key, value;
        g_hash_table_iter_init(&iter, $1);
        while (g_hash_table_iter_next(&iter, &key, &value)) {
            PyDict_SetItemString(dict, (char*)key, PyLong_FromLong((long)GPOINTER_TO_INT(value)));
        }
        g_hash_table_destroy($1);
    }
    $result = dict;
}

/* Typemap: StrBool (Python Dict -> GHashStrBool) */
%typemap(in) GHashStrBool * {
    if (!PyDict_Check($input)) {
        PyErr_SetString(PyExc_TypeError, "Expected a dictionary");
        return NULL;
    }
    /* Value destructor is NULL because we use GINT_TO_POINTER */
    $1 = g_hash_table_new_full(g_str_hash, g_str_equal, g_free, NULL);
    PyObject *key, *value;
    Py_ssize_t pos = 0;
    while (PyDict_Next($input, &pos, &key, &value)) {
        int bool_val = PyObject_IsTrue(value); 
        g_hash_table_insert($1, g_strdup(PyUnicode_AsUTF8(key)), GINT_TO_POINTER(bool_val));
    }
}

/* Typemap: GHashStrBool -> Python Dict */
%typemap(out) GHashStrBool * {
    PyObject *dict = PyDict_New();
    if ($1) {
        GHashTableIter iter; gpointer k, v;
        g_hash_table_iter_init(&iter, $1);
        while (g_hash_table_iter_next(&iter, &k, &v)) {
            PyObject *bool_obj = GPOINTER_TO_INT(v) ? Py_True : Py_False;
            Py_INCREF(bool_obj);
            PyDict_SetItemString(dict, (char*)k, bool_obj);
        }
        g_hash_table_destroy($1);
    }
    $result = dict;
}

/* Typemap: StrFloat (Python Dict -> GHashStrFloat) */
%typemap(in) GHashStrFloat * {
    if (!PyDict_Check($input)) {
        PyErr_SetString(PyExc_TypeError, "Expected a dictionary");
        return NULL;
    }
    /* We use g_free as the value-destroyer so the allocated floats are cleaned up */
    $1 = g_hash_table_new_full(g_str_hash, g_str_equal, g_free, g_free);
    
    PyObject *key, *value;
    Py_ssize_t pos = 0;
    while (PyDict_Next($input, &pos, &key, &value)) {
        float *f_ptr = g_new(float, 1);
        *f_ptr = (float)PyFloat_AsDouble(value);
        g_hash_table_insert($1, g_strdup(PyUnicode_AsUTF8(key)), f_ptr);
    }
}

/* Typemap: GHashStrFloat -> Python Dict */
%typemap(out) GHashStrFloat * {
    PyObject *dict = PyDict_New();
    if ($1) {
        GHashTableIter iter; gpointer k, v;
        g_hash_table_iter_init(&iter, $1);
        while (g_hash_table_iter_next(&iter, &k, &v)) {
            PyDict_SetItemString(dict, (char*)k, PyFloat_FromDouble((double)(*(float*)v)));
        }
        g_hash_table_destroy($1);
    }
    $result = dict;
}

