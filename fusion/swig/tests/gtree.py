import mglib

print("--- Testing GTree with Python ---")

# 1. Test String Tree (Python Dictionary)
py_dict = {
    "Brand": "C-Language",
    "Type": "Balanced-Tree",
    "Library": "GLib"
}

print("Calling print_tree_str with Python dict:")
mglib.print_tree_str(py_dict)

# 2. Test getting a tree from C (returns a Dict)
sample = mglib.get_sample_tree_str()
print(f"\nSample from C: {sample}")

# 3. Test Integer Summation
weights = {"item1": 100, "item2": 250, "item3": 50}
total = mglib.sum_tree_int(weights)
print(f"\nSum of integer values (100+250+50): {total}")
