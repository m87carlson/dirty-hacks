#!/usr/bin/env ruby

require 'listen'
require 'fileutils'
require 'logger'

logger = Logger.new('/tmp/listener_sps.log')

listener = Listen.to('BAYXML-1') do |modified, added, removed|

  modified.each do |item|
    tmp_item = item.split('SPS').last.split('.').first.gsub(/(.zip|.txt|_done)/, '')

    puts "temp item: #{tmp_item}"


    if tmp_item.to_i % 4 == 0
      FileUtils.mv(item, 'BAYXML-1/queue-4/')
      logger.info('move') { "moved #{item} to BAYXML-1/queue-4/"}
    elsif tmp_item.to_i % 3 == 0
      FileUtils.mv(item, 'BAYXML-1/queue-3/')
      logger.info('move') { "moved #{item} to BAYXML-1/queue-3/"}
    elsif tmp_item.to_i % 2 == 0
      FileUtils.mv(item, 'BAYXML-1/queue-2/')
      logger.info('move') { "moved #{item} to BAYXML-1/queue-2/"}
    else
      FileUtils.mv(item, 'BAYXML-1/queue-1/')
      logger.info('move') { "moved #{item} to BAYXML-1/queue-1/"}
    end
  end
end

listener.start
sleep
