#!/usr/bin/env ruby

require 'listen'
require 'logger'
require 'digest'
require 'yaml'

class XML_Demux

  def read_config
    config = YAML.load_file("config.yml")
    @order_type = config["config"]["order_type"]
    @src_dir = config["config"]["src_dir"]
    @log_file = config["config"]["log_file"]
    @debug = config["config"]["debug"]

    if @debug
      puts "DEBUG CONFIG: Config Read..
        #{@order_type}
        #{@src_dir}
        #{@log_file}"
    end
  end

  def lager
    @logger = Logger.new(@log_file)
  end

  def demux
    listener = Listen.to(@src_dir, only: %r{(.zip|.txt)}) do |modified, added, removed|

      added.each do |item|
        tmp_item = item.split(@order_type).last.split('.').first.gsub(/(.zip|.txt|_done)/, '')
        # calculate a checksum
        pre_sum = Digest::MD5.file(item)

        if @debug
          puts "DEBUG DEMUX: pre sum #{pre_sum}"
        end

        if tmp_item.to_i % 4 == 0
          begin
            FileUtils.mv(item, @src_dir + '/queue-4/')
            destination_path = File.join(@src_dir + "/queue-4", File.basename(item))
            post_sum = Digest::MD5.file(destination_path)
            @logger.info('move') { "moved #{item} => #{@src_dir}/queue-4/"}
            @logger.info('md5') { "pre_md5=#{pre_sum} post_md5=#{post_sum}" }
          rescue
            @logger.error "#{item} move failed"
          end
        elsif tmp_item.to_i % 3 == 0
          begin
            FileUtils.mv(item, @src_dir + '/queue-3/')
            destination_path = File.join( @src_dir + "/queue-3", File.basename(item))
            post_sum = Digest::MD5.file(destination_path)
            @logger.info('move') { "moved #{item} => #{@src_dir}/queue-3/"}
            @logger.info('md5') { "pre_md5=#{pre_sum} post_md5=#{post_sum}" }
          rescue
            @logger.error "#{item} move failed"
          end
        elsif tmp_item.to_i % 2 == 0
          begin
            FileUtils.mv(item, @src_dir + '/queue-2/')
            destination_path = File.join( @src_dir + "/queue-2", File.basename(item))
            post_sum = Digest::MD5.file(destination_path)
            @logger.info('move') { "moved #{item} => #{@src_dir}/queue-2/"}
            @logger.info('md5') { "pre_md5=#{pre_sum} post_md5=#{post_sum}" }
          rescue
            @logger.error "#{item} move failed"
          end
        else
          begin
            FileUtils.mv(item, @src_dir + '/queue-1/')
            destination_path = File.join( @src_dir + "/queue-1", File.basename(item))
            post_sum = Digest::MD5.file(destination_path)
            @logger.info('move') { "moved #{item} => #{@src_dir}/queue-1/"}
            @logger.info('md5') { "pre_md5=#{pre_sum} post_md5=#{post_sum}" }
          rescue
            @logger.error "#{item} move failed"
          end
        end
      end
    end
    listener.start
    sleep
  end
end

x_demux = XML_Demux.new
puts "Initialized new XML_Demux class..."
puts "Reading config..."
x_demux.read_config
puts "Setup Logging..."
x_demux.lager
puts "running demuxer"
x_demux.demux
