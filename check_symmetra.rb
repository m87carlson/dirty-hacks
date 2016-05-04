#!/usr/local/bin/ruby

require 'net/ping'

# Sensor host name, hard-coded at the moment
APC_SYM_HOST=ARGV[0]

###
# APC Symmetra OID's
###
APC_SYM_HOSTNAME="sysName.0"
APC_SYM_STATUS="1.3.6.1.4.1.318.1.1.1.4.1.1"
APC_SYM_BATTCAP_OID="1.3.6.1.4.1.318.1.1.1.2.2.1.0"
APC_SYM_BATTTEMP_OID="1.3.6.1.4.1.318.1.1.1.2.2.2.0"
APC_SYM_BATTRUNTIME_OID="1.3.6.1.4.1.318.1.1.1.2.2.3.0"
APC_SYM_INPUTV_OID="1.3.6.1.4.1.318.1.1.1.3.2.1.0"
APC_SYM_OUTPUTV_OID="1.3.6.1.4.1.318.1.1.1.4.2.1.0"
APC_SYM_OUTPUTL_OID="1.3.6.1.4.1.318.1.1.1.4.2.3.0"


def up?(host)
  check = Net::Ping::External.new(host)
  check.ping?
end

def get_apc_status(value)
  apc_status = {
    1 => "unknown",
    2 => "on_line",
    3 => "on_battery",
    4 => "on_smart_boost",
    5 => "timed_sleeping",
    6 => "software_bypass",
    7 => "off",
    8 => "rebooting",
    9 => "switched_bypass",
    10 => "hardware_failure_bypass",
    11 => "sleeping_until_power_returns",
    12 => "on_smart_trim"
  }
  apc_status.fetch(value)
end

def get_snmp_data(oid)
  `/usr/local/bin/snmpwalk -Os -c public -v 1 #{APC_SYM_HOST} #{oid}`.split(" ").last.chomp
end

if up?(APC_SYM_HOST)
  hostname=get_snmp_data(APC_SYM_HOSTNAME)
  status=get_apc_status(get_snmp_data(APC_SYM_STATUS).to_i)
  battery_capacity=get_snmp_data(APC_SYM_BATTCAP_OID)
  battery_temp=(get_snmp_data(APC_SYM_BATTTEMP_OID).to_i * (9.0 / 5.0)) + 32
  runtime=get_snmp_data(APC_SYM_BATTRUNTIME_OID)
  input_voltage=get_snmp_data(APC_SYM_INPUTV_OID)
  output_voltage=get_snmp_data(APC_SYM_OUTPUTV_OID)
  output_load=get_snmp_data(APC_SYM_OUTPUTL_OID)

  `logger "host=#{hostname}|status=#{status}|battery_capacity=#{battery_capacity}|battery_temp=#{battery_temp}|runtime=#{runtime}|input_voltage=#{input_voltage}|output_voltage=#{output_voltage}|output_load=#{output_load}"`
else
  `logger "host=#{APC_SYM_HOST}|battery_capacity=0|battery_temp=0|runtime=0|input_voltage=0|output_voltage=0|output_load=0"`
end
