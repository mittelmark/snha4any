#!/usr/bin/env tclsh

if {[catch load ./mglib.so mglib]} {
   load ./mglib.so
}
puts [lsort [info commands ::*]]
set data {nan NaN 1.1 2.2 4.4 NAN}
puts "Input: $data"
puts "Sum: [mglib::sum_float_array $data]"
puts "Empty list: [mglib::sum_float_array {}]"

set my_list [mglib::create_float_array 5]
puts "Generated Tcl List: $my_list"
# Output: 0.5 1.5 2.5 3.5 4.5

puts "--- Testing Integers ---"
set int_data {10 20 30 40}
set i_sum [mglib::sum_int_array $int_data]
puts "Input Ints: $int_data"
puts "Sum of Ints: $i_sum"

set gen_ints [mglib::create_int_array 5]
puts "Generated Ints from C: $gen_ints"

puts "\n--- Testing Floats & NaN ---"
set float_data {1.1 2.2 nan 4.4}
set f_sum [mglib::sum_float_array $float_data]
puts "Input Floats (with NaN): $float_data"
puts "Sum of Floats: $f_sum"

set gen_floats [mglib::create_float_array 3]
puts "Generated Floats from C: $gen_floats"

puts "\n--- Testing Error Handling ---"
puts "Testing invalid integer input (should show error):"
if {[catch {mglib::sum_int_array {10 abc 30}} err]} {
    puts "Caught expected error: $err"
}

puts "\n--- Testing Empty Lists ---"
puts "Empty Int Sum: [mglib::sum_int_array {}]"
puts "Empty Float Sum: [mglib::sum_float_array {}]"

# Test Strings
puts "String Lengths: [mglib::sum_string_lengths {Hello World}]"
puts "Strings from C: [mglib::create_string_array]"

# Test Booleans
set bool_list {true false 1 0 yes no}
puts "True count in $bool_list: [mglib::count_true_values $bool_list]"
puts "Bools from C: [mglib::create_bool_array 4]"

set data {1 2 3 4}
puts "Array Sum: [mglib::sum_int_array $data]"

