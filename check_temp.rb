#!/usr/local/bin/ruby

SENSOR1_TEMP=`snmpwalk -Os -c public -v 1 10.5.68.58 1.3.6.1.4.1.318.1.1.10.3.13.1.1.3.1`.split(" ").last.chomp
SENSOR1_HUMIDITY=`snmpwalk -Os -c public -v 1 10.5.68.58 1.3.6.1.4.1.318.1.1.10.3.13.1.1.6.1`.split(" ").last.chomp
SENSOR2_TEMP=`snmpwalk -Os -c public -v 1 10.5.68.58 1.3.6.1.4.1.318.1.1.10.3.13.1.1.3.2`.split(" ").last.chomp
SENSOR2_HUMIDITY=`snmpwalk -Os -c public -v 1 10.5.68.58 1.3.6.1.4.1.318.1.1.10.3.13.1.1.6.2`.split(" ").last.chomp

puts "host=mc-weather2|sensor1_temp=#{SENSOR1_TEMP}|sendor1_humidity=#{SENSOR1_HUMIDITY}|sensor2_temp=#{SENSOR2_TEMP}|sensor2_humidity=#{SENSOR2_HUMIDITY}"
