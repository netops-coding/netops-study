require "active_record"
require "mysql2"
require "sinatra"
require "sinatra/reloader"
require "net/netconf"
require "net/netconf/jnpr"

# DB設定ファイルの読み込み
ActiveRecord::Base.configurations = YAML.load_file("database.yml")
ActiveRecord::Base.establish_connection(:development)

# クラス作成
class SetInterface
  def initialize(id)
    @id = id
  end

  class RouterDB < ActiveRecord::Base
  end

  def set_interface
    value = RouterDB.find_by id: (@id)
    id = value.id
    unit = value.unit
    vlan = value.unit
    description = value.description


Netconf::SSH.new(target: ENV['ROUTER_IP'], username: ENV['ROUTER_USER'], password: ENV['ROUTER_PASSWORD']) do |device|
      puts device.rpc.lock(:candidate)
      puts device.rpc.load_configuration( :format => "set" ) {
        "set interfaces ge-0/0/0 unit #{unit} vlan-id #{vlan} description #{description}"
      }
      puts device.rpc.validate(:candidate)
      puts device.rpc.commit
      puts device.rpc.unlock :candidate
    end
  end
end

post "/set_interface" do
  # リクエスト解析
  reqData = JSON.parse(request.body.read.to_s)
  id = reqData["id"]

  set_config = SetInterface.new(id)
  set_config.set_interface

  # レスポンスコード
  status 202
end

