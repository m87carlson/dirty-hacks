#!/usr/local/bin/ruby

SENSOR_HOST="mc-weather02"

def get_temperature(oid, id)
  `/usr/local/bin/snmpwalk -Os -c public -v 1 #{SENSOR_HOST} #{oid}#{id}`.split(" ").last.chomp
end


(1..2).each do |sensor|
  temp=get_temperature("1.3.6.1.4.1.318.1.1.10.3.13.1.1.3.",sensor.to_s )
  humidity=get_temperature("1.3.6.1.4.1.318.1.1.10.3.13.1.1.6.",sensor.to_s)
  `logger "host=#{SENSOR_HOST}|sensor=#{sensor}|temp=#{temp}|humidity=#{humidity}"`
end
