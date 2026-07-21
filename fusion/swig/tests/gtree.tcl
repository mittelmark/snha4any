#!/usr/bin/env tclsh
if {[catch load ./mglib.so mglib]} {
   load ./mglib.so
}

puts "--- Testing GTree with Tcl ---"

# 1. Test String Tree (Dictionary pattern)
set my_data {
    "Name"     "Gemini"
    "Version"  "2.5"
    "Language" "Tcl"
}

puts "Calling print_tree_str with Tcl dict:"
mglib::print_tree_str $my_data

# 2. Test getting a tree from C
puts "\nFetching sample tree from C:"
set sample [mglib::get_sample_tree_str]
puts "Received: $sample"

# 3. Test Integer Summation
set int_data {
    "apples"  10
    "oranges" 20
    "bananas" 30
}
set total [mglib::sum_tree_int $int_data]
puts "\nSum of integer values (10+20+30): $total"

