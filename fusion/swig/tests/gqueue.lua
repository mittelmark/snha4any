#!/usr/bin/env lua

-- test_gqueue.lua
local mglib = require("mglib")

print("--- Testing GQueue with Lua ---")

-- 1. Integer Queue Test
-- Input: Lua Table -> C: GIntQueue
local my_nums = {10, 20, 30, 40, 50}
print("Summing integers from Lua table: " .. table.concat(my_nums, ", "))

local total = mglib.sum_int_queue(my_nums)
print("Result from C sum_queue_int: " .. total)

-- Output: C: GIntQueue -> Lua Table
local sample_nums = mglib.get_sample_int_queue()
print("Sample integers from C: " .. table.concat(sample_nums, ", "))

-- 2. String Queue Test
-- Input: Lua Table -> C: GStringQueue
local my_strs = {"Lua", "is", "fast"}
print("\nCounting lengths of strings: " .. table.concat(my_strs, " "))

local char_count = mglib.sum_string_queue_lengths(my_strs)
print("Total characters from C: " .. char_count)

-- Output: C: GStringQueue -> Lua Table
local sample_strs = mglib.get_sample_str_queue()
print("Sample strings from C:")
for i, v in ipairs(sample_strs) do
    print("  [" .. i .. "] " .. v)
end

-- 3. Boolean Queue Test (NEW)
-- Input: Lua Table (booleans) -> C: GBoolQueue
local my_bools = {true, false, true, true, false}
print("\nTesting Boolean Queue: " .. table.concat({ "true", "false", "true", "true", "false" }, ", "))

-- Calls count_true_queue(GBoolQueue *queue) 
local true_count = mglib.count_true_queue(my_bools)
print("Number of 'true' values from C: " .. true_count)

-- Output: C: GBoolQueue -> Lua Table
local sample_bools = mglib.create_bool_queue(3) -- Creates a queue of size 3
print("Sample booleans from C:")
for i, v in ipairs(sample_bools) do
    print("  [" .. i .. "] " .. tostring(v))
end


-- 4. Float Queue Test (NEW)
-- Input: Lua Table (numbers) -> C: GFloatQueue
local my_floats = {1.5, 2.5, 3.5}
print("\nSumming floats from Lua table: 1.5, 2.5, 3.5")

-- Calls sum_float_queue(GFloatQueue *queue) 
local float_sum = mglib.sum_float_queue(my_floats)
print("Result from C sum_float_queue: " .. float_sum)

-- Output: C: GFloatQueue -> Lua Table
local sample_floats = mglib.create_float_queue(4)
print("Sample floats from C:")
for i, v in ipairs(sample_floats) do
    print("  [" .. i .. "] " .. string.format("%.2f", v))
end
