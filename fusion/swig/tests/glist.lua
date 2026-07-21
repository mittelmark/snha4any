#!/usr/bin/env lua

-- Load the library
local mglib = require("mglib")

print("--- Lua: Testing GListStr ---")
local tags = {"Urgent", "Internal", "Archived"}

-- Test IN Typemap: Lua Table -> GListStr*
mglib.print_list_str(tags)

-- Test OUT Typemap: GListStr* -> Lua Table
local c_tags = mglib.get_sample_list_str()
print("Tags returned from C:")
for i, v in ipairs(c_tags) do
    print("  [" .. i .. "] = " .. v)
end

print("\n--- Lua: Testing GListInt ---")
local values = {100, 200, 300}

-- Test IN Typemap
local total = mglib.sum_list_int(values)
print("Total sum from C:", total)

-- Test OUT Typemap
local c_ints = mglib.get_sample_list_int()
print("First integer from C list:", c_ints[1])

