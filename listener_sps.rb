#!/usr/bin/env ruby

require 'listen'
require 'fileutils'
require 'logger'
require 'digest'

logger = Logger.new('/tmp/listener_sps.log')

listener = Listen.to('BAYXML-1') do |modified, added, removed|

  modified.each do |item|
    tmp_item = item.split('SPS').last.split('.').first.gsub(/(.zip|.txt|_done)/, '')

    # calculate a checksum
    pre_sum = Digest::MD5.file(item)


    if tmp_item.to_i % 4 == 0
      begin
        FileUtils.mv(item, 'BAYXML-1/queue-4/')
        logger.info('move') { "moved #{item} to BAYXML-1/queue-4/"}
        logger.info('md5') { "MD5=#{pre_sum}" }
      rescue
        logger.error "#{item} move failed"
      end
    elsif tmp_item.to_i % 3 == 0
      begin
        FileUtils.mv(item, 'BAYXML-1/queue-3/')
        logger.info('move') { "moved #{item} to BAYXML-1/queue-3/"}
        logger.info('md5') { "MD5=#{pre_sum}" }
      rescue
        logger.error "#{item} move failed"
      end
    elsif tmp_item.to_i % 2 == 0
      begin
        FileUtils.mv(item, 'BAYXML-1/queue-2/')
        logger.info('move') { "moved #{item} to BAYXML-1/queue-2/"}
        logger.info('md5') { "MD5=#{pre_sum}" }
      rescue
        logger.error "#{item} move failed"
      end
    else
      begin
        FileUtils.mv(item, 'BAYXML-1/queue-1/')
        logger.info('move') { "moved #{item} to BAYXML-1/queue-1/"}
        logger.info('md5') { "MD5=#{pre_sum}" }
      rescue
        logger.error "#{item} move failed"
      end
    end
  end
end

listener.start
sleep
