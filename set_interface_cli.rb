require "net/netconf"
require "net/netconf/jnpr"

Netconf::SSH.new(target: ENV['ROUTER_IP'], username: ENV['ROUTER_USER'], password: ENV['ROUTER_PASSWORD']) do |device|
  puts device.rpc.lock_configuration
  puts device.rpc.load_configuration( :format => 'set' ) {
    "set interfaces ge-0/0/0 unit 1 vlan-id 1 description netopscoding1_cli\n
    set interfaces ge-0/0/0 unit 2 vlan-id 2 description netopscoding2_cli"
  }
  puts device.rpc.check_configuration
  puts device.rpc.commit_configuration
  puts device.rpc.unlock_configuration
end

