#!/usr/bin/env tclsh

if {[catch load ./mglib.so mglib]} {
   load ./mglib.so
}

set conf [dict create "key" "value" "key2" "value2"]
puts $conf
puts "Hash Count: [mglib::count_keys $conf]"

puts "--- Tcl: Testing StrFloat ---"
set pricing [dict create apple 0.99 banana 0.50 cherry 2.75]

# 1. Test Retrieval
set price [mglib::get_value_str_float $pricing "cherry"]
puts [format "Cherry Price: %.2f" $price]

# 2. Test Count
puts "Pricing items: [mglib::count_keys $pricing]"

puts "\n--- Tcl: Testing StrBool ---"
# Tcl booleans can be true/false, yes/no, or 1/0
set flags [dict create active true experimental no production 1]

# 1. Test Retrieval
set is_active [mglib::get_value_str_bool $flags "active"]
set is_exp    [mglib::get_value_str_bool $flags "experimental"]

puts "Is Active: $is_active"
puts "Is Experimental: $is_exp"

# 2. Test Logical check in Tcl
if {$is_active} {
    puts "System is active!"
}

