#!/usr/bin/env lua

-- Load the library
local mglib = require("mglib")

-- Test with standard numbers and NaN
local data = {1.1, 2.2, 0/0, 4.4} -- 0/0 is a common way to get NaN in Lua

print("Input table contains NaN: " .. tostring(data[3]))

local result = mglib.sum_float_array(data)
print("Sum from C: " .. result)

-- Test empty table
print("Empty sum: " .. mglib.sum_float_array({}))

-- Generate an array of 10 floats from C
local my_list = mglib.create_float_array(10)

print("Received table of size: " .. #my_list)
for i, v in ipairs(my_list) do
    print(string.format("Index %d: %.2f", i, v))
end

-- Test Strings
local words = {"Lua", "is", "fast"}
print("String lengths total: " .. mglib.sum_string_lengths(words))
local c_words = mglib.create_string_array()
print("From C: " .. table.concat(c_words, ", "))

-- Test Booleans
local flags = {true, false, true}
print("True count: " .. mglib.count_true_values(flags))
local c_flags = mglib.create_bool_array(4)
for i, v in ipairs(c_flags) do 
    print("Bool " .. i .. ": " .. tostring(v)) end

-- Load the shared library
local mglib = require("mglib")

print("--- Testing GHashStrStr (String-to-String) ---")
local user_os = {
    alice = "Linux",
    bob = "macOS",
    charlie = "Windows"
}

-- 1. Test Generic Count (Uses the %inline lua_State logic)
local count = mglib.count_keys(user_os)
print("Count (should be 3):", count)

-- 2. Test Retrieval (Uses typemap(in) for GHashStrStr)
-- This converts the Lua table to a GHashTable, calls C, then destroys C table
local bob_val = mglib.get_value_str_str(user_os, "bob")
print("Bob's OS:", bob_val)

---

print("\n--- Testing GHashStrInt (String-to-Integer) ---")
local scores = {
    level_1 = 1500,
    level_2 = 3200,
    level_3 = 5000
}

-- 1. Test Retrieval
local s2 = mglib.get_value_str_int(scores, "level_2")
print("Level 2 Score:", s2)

-- 2. Test Count
print("Scores Count:", mglib.count_keys(scores))

---

print("\n--- Testing 'Out' Typemaps (C to Lua) ---")
-- Assuming you have a C function like 'create_sample_config()' 
-- that returns a GHashStrStr*
if mglib.create_int_config then
    local c_table = mglib.create_int_config()
    print("Table returned from C:")
    for k, v in pairs(c_table) do
        print("  " .. k .. " => " .. tostring(v))
    end
else
    print("Note: create_int_config not implemented in C yet.")
end

print("--- Lua: Testing StrFloat ---")
local physics_constants = {
    gravity = 9.806,
    planck = 6.626,
    electron_volt = 1.602
}

-- 1. Test Retrieval from C
local g = mglib.get_value_str_float(physics_constants, "gravity")
print(string.format("Gravity from C: %.3f", g))

-- 2. Test Generic Count
print("Constants Count:", mglib.count_keys(physics_constants))

---

print("\n--- Lua: Testing StrBool ---")
local settings = {
    enable_logging = true,
    use_cache = false,
    verbose = true
}

-- 1. Test Retrieval (Lua expects a boolean or 0/1 depending on your C return type)
local logging = mglib.get_value_str_bool(settings, "enable_logging")
print("Logging Enabled:", tostring(logging))

-- 2. Test Round-trip (If you have a function returning a GHashStrBool*)
if mglib.get_default_settings then
    local defaults = mglib.get_default_settings()
    for k, v in pairs(defaults) do
        print("Default Setting:", k, "=>", tostring(v))
    end
end

