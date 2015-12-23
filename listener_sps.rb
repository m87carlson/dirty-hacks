#!/usr/bin/env ruby

require 'listen'
require 'fileutils'
require 'logger'
require 'digest'
require 'yaml'

#logger = Logger.new('/tmp/listener_sps.log')

def read_config
  config = YAML.load_file("config.yml")
  @order_type = config["config"]["order_type"]
  @src_dir = config["config"]["src_dir"]
  @log_file = config["config"]["log_file"]
end

def lager log_file
  @logger = Logger.new(log_file)
end

read_config
lager(@log_file)

listener = Listen.to(@src_dir) do |modified, added, removed|

  modified.each do |item|
    tmp_item = item.split(@order_type).last.split('.').first.gsub(/(.zip|.txt|_done)/, '')

    # calculate a checksum
    pre_sum = Digest::MD5.file(item)


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
