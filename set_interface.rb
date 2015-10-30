require "net/netconf"

Netconf::SSH.new(target: ENV['ROUTER_IP'], username: ENV['ROUTER_USER'], password: ENV['ROUTER_PASSWORD']) do |device|
  puts device.rpc.lock(:candidate)
  puts device.rpc.edit_config {|x|
    x.configuration {
      x.interfaces {
        x.interface {
          x.name "ge-0/0/0"
          x.unit {
            x.name "1"
            x.description "description_netops1030"
            x.send("vlan-id",1)
          }
        }
      }
    }
  }
  puts device.rpc.validate(:candidate)
  puts device.rpc.commit
  puts device.rpc.unlock :candidate
end

