#!/usr/bin/env python3

import mglib

print("--- Python: Testing GListStr ---")
colors = ["Red", "Green", "Blue"]
# Test In: Passing list to C
mglib.print_list_str(colors)

# Test Out: Getting list from C
sample_strs = mglib.get_sample_list_str()
print(f"Strings from C: {sample_strs} (Type: {type(sample_strs)})")

print("\n--- Python: Testing GListInt ---")
nums = [100, 200, 300]
# Test In: Summing integers in C
total = mglib.sum_list_int(nums)
print(f"Sum from C: {total}")

# Test Out: Getting ints from C
sample_ints = mglib.get_sample_list_int()
print(f"Integers from C: {sample_ints}")

print("--- Python: Testing GListStr (String List) ---")
# Test IN Typemap: Python List -> GListStr*
colors = ["Cyan", "Magenta", "Yellow", "Black"]
mglib.print_list_str(colors)

# Test OUT Typemap: GListStr* -> Python List
sample_strs = mglib.get_sample_list_str()
print(f"Received from C: {sample_strs} | Type: {type(sample_strs)}")

print("\n--- Python: Testing GListInt (Integer List) ---")
# Test IN Typemap: Python List -> GListInt*
nums = [5, 10, 15, 20]
sum_val = mglib.sum_list_int(nums)
print(f"Sum calculated in C: {sum_val}")

# Test OUT Typemap: GListInt* -> Python List
sample_ints = mglib.get_sample_list_int()
print(f"Integers from C: {sample_ints}")
