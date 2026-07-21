#!/usr/bin/env python3

import mglib


# --- 1. Test Generic Count (%inline PyObject version) ---
print("--- Testing Generic count_keys ---")
data = {"a": 1, "b": 2, "c": 3, "d": 4}
print(f"Count (should be 4): {mglib.count_keys(data)}")

# --- 2. Test GHashStrStr (String to String) ---
print("\n--- Testing GHashStrStr ---")
user_map = {"admin": "root", "guest": "user123"}
val = mglib.get_value_str_str(user_map, "admin")
print(f"Admin value: {val}")

# --- 3. Test GHashStrInt (String to Integer) ---
print("\n--- Testing GHashStrInt ---")
config = {"port": 8080, "timeout": 30}
port = mglib.get_value_str_int(config, "port")
print(f"Port value: {port}")

# --- 4. Test GHashStrBool (String to Boolean) ---
print("\n--- Testing GHashStrBool ---")
flags = {"enabled": True, "debug": False}
is_enabled = mglib.get_value_str_bool(flags, "enabled")
print(f"Enabled (should be 1 or True): {is_enabled}")

# --- 5. Test GHashStrFloat (String to Float) ---
print("\n--- Testing GHashStrFloat ---")
stats = {"pi": 3.14159, "e": 2.718}
pi_val = mglib.get_value_str_float(stats, "pi")
print(f"Pi value: {pi_val:.5f}")

# --- 6. Test 'Out' Typemap (C to Python) ---
if hasattr(mglib, 'create_int_config'):
    print("\n--- Testing Out Typemap (C -> Py) ---")
    c_dict = mglib.create_int_config()
    print(f"Dictionary from C: {c_dict}")
    print(f"Type check: {type(c_dict)}")
    

