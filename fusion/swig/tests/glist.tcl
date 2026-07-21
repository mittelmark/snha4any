#!/usr/bin/env tclsh
if {[catch load ./mglib.so mglib]} {
   load ./mglib.so
}

puts "--- Tcl: Testing GListStr ---"
set tcl_list {Development Production Testing}

puts "here 1"
# Test IN Typemap: Tcl List -> GListStr*
mglib::print_list_str $tcl_list
puts "here 2"

# Test OUT Typemap: GListStr* -> Tcl List
set from_c [mglib::get_sample_list_str]
puts "Strings from C: $from_c"
puts "Second element: [lindex $from_c 1]"

puts "\n--- Tcl: Testing GListInt ---"
set num_list {1 2 3 4 5}

# Test IN Typemap
set total [mglib::sum_list_int $num_list]
puts "Sum from C: $total"

# Test OUT Typemap
set ints_from_c [mglib::get_sample_list_int]
puts "Integers from C: $ints_from_c"


