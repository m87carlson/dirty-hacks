#!/usr/bin/env ruby
require 'fileutils'

# Define the MugsyClicks manual upload directory is
mugsy_data_dir = "/data/mugsyclicks/000_NoImport_NoEmail"

# Match all sub-directories, process each one.
Dir.glob("#{mugsy_data_dir}/*").each do |dir| 

  # If the directory has a known bad character:
  #  * Whitespace
  #  * $
  #  * !
  #  * :
  # Then strip it out.
  # 
  # Using \W would have been easier and more readable,
  #  however, we allow for dashes ("-").
  if dir.to_str.match(/[\s|\\|:|$|!]/)
    fixed_dir = dir.to_str.gsub(/[\s|\\|:|$|!]/, '')
    puts "Renaming #{dir.to_str} to #{fixed_dir}"
    # Move the directory from the old name,
    # to the new name.
    FileUtils.mv dir.to_str, fixed_dir
  end

end
