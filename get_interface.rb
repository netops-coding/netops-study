require "net/netconf"

Netconf::SSH.new(target: ENV['ROUTER_IP'], username: ENV['ROUTER_USER'], password: ENV['ROUTER_PASSWORD']) do |device|
  show = device.rpc.get_interface_information( :interface_name => "ge-0/0/0.1", :detail => true )

  name = show.xpath("//name")
  desc = show.xpath("//description")
#  input_bytes = show.xpath("//input-bytes")
#  output_bytes = show.xpath("//output-bytes")
#  input_bps = show.xpath("//input-bps")
#  output_bps = show.xpath("//output-bps")

  show_summary = name + desc

  puts show_summary

end

