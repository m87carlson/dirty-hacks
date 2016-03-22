#!/usr/bin/env ruby

require 'cupsffi'

#list remote printers on the CUPS server called print.
remote_printers = CupsPrinter.get_all_printer_names(:hostname => 'print')
puts "List of printers #{remote_printers}"

# create new printer instance for one of the printers (test-1)
printer = CupsPrinter("test-1", :hostname => 'print' )
puts "Printer Attributes: #{printer.attributes}"
puts "State: #{printer.state}"

# print out test string:
job = printer.print_date('Hello World!', 'text/plain')
puts "Job Status: #{job.status}"
