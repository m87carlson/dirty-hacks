#!/usr/local/bin/ruby

SENSOR_HOST="mc-weather02"

def get_temperature(id)
  `snmpwalk -Os -c public -v 1 #{SENSOR_HOST} #{id}`.split(" ").last.chomp
end

sensor1_temp=get_temperature "1.3.6.1.4.1.318.1.1.10.3.13.1.1.3.1"
sensor1_humidity=get_temperature "1.3.6.1.4.1.318.1.1.10.3.13.1.1.6.1"
sensor2_temp=get_temperature  "1.3.6.1.4.1.318.1.1.10.3.13.1.1.3.2"
sensor2_humidity=get_temperature "1.3.6.1.4.1.318.1.1.10.3.13.1.1.6.2"

puts "host=#{SENSOR_HOST}|sensor1_temp=#{sensor1_temp}|sendor1_humidity=#{sensor1_humidity}|sensor2_temp=#{sensor2_temp}|sensor2_humidity=#{sensor2_humidity}"
