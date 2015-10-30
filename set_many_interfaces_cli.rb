require "net/netconf"
require "net/netconf/jnpr"

config = ""
for i in 1..10
  config << "set interfaces ge-0/0/0 unit #{i} vlan-id #{i} description netopscoding#{i}_cli\n"
end

Netconf::SSH.new(target: ENV['ROUTER_IP'], username: ENV['ROUTER_USER'], password: ENV['ROUTER_PASSWORD']) do |device|
  puts device.rpc.lock_configuration
  puts device.rpc.load_configuration( :format => 'set' ) {
    config
  }
  puts device.rpc.check_configuration
  puts device.rpc.commit_configuration
  puts device.rpc.unlock_configuration
end

