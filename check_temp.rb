#!/usr/local/bin/ruby

require 'net/ping'

# Sensor host name, hard-coded at the moment
SENSOR_HOST=ARGV[0]

###
# APC Environment Monitoring Unit SNMP OIDs for 
# temperature and humidity
###
APC_EMU_TEMP_OID="1.3.6.1.4.1.318.1.1.10.3.13.1.1.3."
APC_EMU_HUMID_OID="1.3.6.1.4.1.318.1.1.10.3.13.1.1.6."

def up?(host)
  check = Net::Ping::External.new(host)
  check.ping?
end

def get_snmp_data(oid, id)
  `/usr/local/bin/snmpwalk -Os -c public -v 1 #{SENSOR_HOST} #{oid}#{id}`.split(" ").last.chomp
end

if up?(SENSOR_HOST)
  (1..2).each do |sensor|
    temp=get_snmp_data(APC_EMU_TEMP_OID, sensor.to_s )
    humidity=get_snmp_data(APC_EMU_HUMID_OID,sensor.to_s)
    `logger "host=#{SENSOR_HOST}|sensor=#{sensor}|temp=#{temp}|humidity=#{humidity}"`
  end
else
  `logger "host=#{SENSOR_HOST}|sensor=0|temp=0|humidity=0"`
end
