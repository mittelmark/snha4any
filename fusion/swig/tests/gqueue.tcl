#!/usr/bin/env tclsh

if {[catch load ./mglib.so mglib]} {
   load ./mglib.so
}

puts "--- Testing GQueue with Tcl ---"

# 1. Integer Queue Test
# Input: Tcl List -> C: GIntQueue
set my_nums {10 20 30 40 50}
puts "Summing integers from Tcl list: [join $my_nums {, }]"

set total [mglib::sum_int_queue $my_nums]
puts "Result from C sum_int_queue: $total"

# Output: C: GIntQueue -> Tcl List
set sample_nums [mglib::get_sample_int_queue]
puts "Sample integers from C: [join $sample_nums {, }]"


# 2. String Queue Test
# Input: Tcl List -> C: GStringQueue
set my_strs {Tcl is dynamic}
puts "\nCounting lengths of strings: [join $my_strs { }]"

set char_count [mglib::total_length_queue $my_strs]
puts "Total characters from C: $char_count"

# Output: C: GStringQueue -> Tcl List
set sample_strs [mglib::get_sample_str_queue]
puts "Sample strings from C:"
set i 0
foreach v $sample_strs {
    puts "  \[$i\] $v"
    incr i
}

# 3. Boolean Queue Test (NEW)
# Input: Tcl List -> C: GBoolQueue
set my_bools {true false true true}
puts "\nTesting Boolean Queue: [join $my_bools {, }]"

# Calls count_true_queue_tcl via the %rename in gqueue.i
set true_count [mglib::count_true_queue $my_bools]
puts "Number of 'true' values from C: $true_count"

# Output: C: GBoolQueue -> Tcl List
set sample_bools [mglib::create_bool_queue 3]
puts "Sample booleans from C: [join $sample_bools {, }]"


# 4. Float Queue Test (NEW)
# Input: Tcl List -> C: GFloatQueue
set my_floats {1.1 2.2 3.3}
puts "\nSumming floats from Tcl list: [join $my_floats {, }]"

# Calls sum_float_queue_tcl via the %rename in gqueue.i
set float_sum [mglib::sum_float_queue $my_floats]
puts "Result from C sum_float_queue: [format %.2f $float_sum]"

# Output: C: GFloatQueue -> Tcl List
set sample_floats [mglib::create_float_queue 4]
puts "Sample floats from C:"
set i 0
foreach v $sample_floats {
    puts "  \[$i\] [format %.2f $v]"
    incr i
}
