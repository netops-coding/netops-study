require "net/netconf"

Netconf::SSH.new(target: ENV['ROUTER_IP'], username: ENV['ROUTER_USER'], password: ENV['ROUTER_PASSWORD']) do |device|
  puts device.rpc.lock(:candidate)
  for i in 1..10
  puts device.rpc.edit_config {|x|
    x.configuration {
      x.interfaces {
        x.interface {
          x.name "ge-0/0/0"
          x.unit("operation"=>"delete"){
            x.name "#{i}"
          }
        }
      }
    }
  }
  end
  puts device.rpc.validate(:candidate)
  puts device.rpc.commit
  puts device.rpc.unlock :candidate
end

