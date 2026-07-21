%{
/* Helper function for g_tree_foreach to populate Python dictionary (String Tree) */
static gboolean tree_to_py_dict_str(gpointer key, gpointer value, gpointer data) {
    PyObject *dict = (PyObject *)data;
    PyObject *py_key = PyUnicode_FromString((const char *)key);
    PyObject *py_val = PyUnicode_FromString((const char *)value);
    PyDict_SetItem(dict, py_key, py_val);
    Py_DECREF(py_key);
    Py_DECREF(py_val);
    return FALSE; 
}

/* Helper function for g_tree_foreach to populate Python dictionary (Int Tree) */
static gboolean tree_to_py_dict_int(gpointer key, gpointer value, gpointer data) {
    PyObject *dict = (PyObject *)data;
    PyObject *py_key = PyUnicode_FromString((const char *)key);
    PyObject *py_val = PyLong_FromLong((long)GPOINTER_TO_INT(value));
    PyDict_SetItem(dict, py_key, py_val);
    Py_DECREF(py_key);
    Py_DECREF(py_val);
    return FALSE; 
}
%}

/* ================================================================= 
   GTreeStr (String keys, String values)
   ================================================================= */

%typemap(in) GTreeStr * {
    if (!PyDict_Check($input)) {
        PyErr_SetString(PyExc_TypeError, "Expected a dictionary {string: string}");
        return NULL;
    }

    /* Use g_tree_new with g_strcmp0 to match compiler signature */
    $1 = (GTreeStr*)g_tree_new((GCompareFunc)g_strcmp0);

    PyObject *key, *value;
    Py_ssize_t pos = 0;

    while (PyDict_Next($input, &pos, &key, &value)) {
        PyObject *key_str = PyObject_Str(key);
        PyObject *val_str = PyObject_Str(value);
        
        const char *c_key = PyUnicode_AsUTF8(key_str);
        const char *c_val = PyUnicode_AsUTF8(val_str);

        g_tree_insert((GTree*)$1, g_strdup(c_key), g_strdup(c_val));

        Py_DECREF(key_str);
        Py_DECREF(val_str);
    }
}

%typemap(out) GTreeStr * {
    $result = PyDict_New();
    if ($1) {
        g_tree_foreach((GTree *)$1, (GTraverseFunc)tree_to_py_dict_str, $result);
    }
}

%typemap(freearg) GTreeStr * {
    if ($1) g_tree_destroy((GTree*)$1);
}

/* ================================================================= 
   GTreeInt (String keys, Integer values)
   ================================================================= */

%typemap(in) GTreeInt * {
    if (!PyDict_Check($input)) {
        PyErr_SetString(PyExc_TypeError, "Expected a dictionary {string: int}");
        return NULL;
    }

    $1 = (GTreeInt*)g_tree_new((GCompareFunc)g_strcmp0);

    PyObject *key, *value;
    Py_ssize_t pos = 0;

    while (PyDict_Next($input, &pos, &key, &value)) {
        PyObject *key_str = PyObject_Str(key);
        long c_val = PyLong_AsLong(value);
        
        if (PyErr_Occurred()) {
            Py_DECREF(key_str);
            g_tree_destroy((GTree*)$1);
            return NULL;
        }

        const char *c_key = PyUnicode_AsUTF8(key_str);
        g_tree_insert((GTree*)$1, g_strdup(c_key), GINT_TO_POINTER((int)c_val));

        Py_DECREF(key_str);
    }
}

%typemap(out) GTreeInt * {
    $result = PyDict_New();
    if ($1) {
        g_tree_foreach((GTree *)$1, (GTraverseFunc)tree_to_py_dict_int, $result);
    }
}

%typemap(freearg) GTreeInt * {
    if ($1) g_tree_destroy((GTree*)$1);
}
