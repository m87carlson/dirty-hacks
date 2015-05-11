require 'fileutils'

mugsy_data_no_import_dir = "/home/DISCDRIVE/mikec/projects/mugsy_testing/000_NoImport_NoEmail"

Dir.glob("#{mugsy_data_no_import_dir}/*").each do |dir| 
  if dir.to_str.match(/[\s|\\|:|$|!]/)
    fixed_dir = dir.to_str.gsub(/[\s|\\|:|$|!]/, '')
    puts "bad dir = #{fixed_dir}"
    puts "Renaming..."
    FileUtils.mv dir.to_str, fixed_dir
  end

end
