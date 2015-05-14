#!/usr/bin/env ruby

# input file
ARGV.each do |a|
  puts "Input: #{a}"
  INPUT = a
end

if INPUT == 'zfs-3.txt'
  PARENT_DIR = '/data/zfs-2-backup'
else
  PARENT_DIR = '/data'
end

f = File.open(INPUT, "r")

f.each_line do |line|
  d = "#{PARENT_DIR}/#{line.split('|')[3]}/#{line.split('|')[6]}"
  order_dir = d.chomp

  puts "Order Directory: #{order_dir}"

  if File.exists?(order_dir) && File.directory?(order_dir)
    puts "Order Directory: #{order_dir} exists, printable not removable"
  else
    printable_dir = order_dir.sub('_ORDERS', '_PRINTABLES')
    puts "Cleaning up Printable folder: #{printable_dir}"
    #FileUtiles.rm_rf(printable_dir)
  end
end

f.close
