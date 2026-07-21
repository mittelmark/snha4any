#!/usr/bin/env python3
import mglib

print("--- Testing GQueue with Python ---")

# 1. Integer Queue Test
# Input: Python List -> C: GIntQueue
my_nums = [10, 20, 30, 40, 50]
print(f"Summing integers from Python list: {', '.join(map(str, my_nums))}")

total = mglib.sum_int_queue(my_nums)
print(f"Result from C sum_int_queue: {total}")

# Output: C: GIntQueue -> Python List
sample_nums = mglib.get_sample_int_queue()
print(f"Sample integers from C: {', '.join(map(str, sample_nums))}")


# 2. String Queue Test
# Input: Python List -> C: GStringQueue
my_strs = ["Python", "is", "powerful"]
print(f"\nCounting lengths of strings: {' '.join(my_strs)}")

# Note: Using the function name defined in gqueue.i / gqueue.h
char_count = mglib.total_length_queue(my_strs)
print(f"Total characters from C: {char_count}")

# Output: C: GStringQueue -> Python List
sample_strs = mglib.get_sample_str_queue()
print("Sample strings from C:")
for i, v in enumerate(sample_strs):
    print(f"  [{i}] {v}")

# 3. Boolean Queue Test (NEW)
# Input: Python List (bools) -> C: GBoolQueue
my_bools = [True, False, True, True]
print(f"\nTesting Boolean Queue: {', '.join(map(str, my_bools))}")

# Calls count_true_queue(GBoolQueue *queue)
true_count = mglib.count_true_queue(my_bools)
print(f"Number of 'True' values from C: {true_count}")

# Output: C: GBoolQueue -> Python List
sample_bools = mglib.create_bool_queue(3)
print("Sample booleans from C:")
for i, v in enumerate(sample_bools):
    print(f"  [{i}] {v}")


# 4. Float Queue Test (NEW)
# Input: Python List (floats) -> C: GFloatQueue
my_floats = [1.1, 2.2, 3.3]
print(f"\nSumming floats from Python list: {', '.join(map(str, my_floats))}")

# Calls sum_float_queue(GFloatQueue *queue)
float_sum = mglib.sum_float_queue(my_floats)
print(f"Result from C sum_float_queue: {float_sum:.2f}")

# Output: C: GFloatQueue -> Python List
sample_floats = mglib.create_float_queue(4)
print("Sample floats from C:")
for i, v in enumerate(sample_floats):
    print(f"  [{i}] {v:.2f}")
