#!/usr/bin/env lua
local mglib = require("mglib")

print("--- Testing GTree with Lua ---")

-- 1. Test String Tree (Lua Table)
local my_table = {
    OS = "Linux",
    Kernel = "GLib",
    Interface = "SWIG"
}

print("Calling print_tree_str with Lua table:")
mglib.print_tree_str(my_table)

-- 2. Test getting a tree from C (returns a Table)
local sample = mglib.get_sample_tree_str()
print("\nSample from C:")
for k, v in pairs(sample) do
    print("  " .. k .. ": " .. v)
end

-- 3. Test Integer Summation
local counts = {a = 5, b = 15, c = 80}
local total = mglib.sum_tree_int(counts)
print("\nSum of integer values (5+15+80): " .. total)
