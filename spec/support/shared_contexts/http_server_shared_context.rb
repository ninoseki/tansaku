# frozen_string_literal: true

require "glint"
require "webrick"

RSpec.shared_context "http_server" do
  def server
    server = Glint::Server.new do |port|
      http = WEBrick::HTTPServer.new(
        BindAddress: "0.0.0.0",
        Port: port,
        Logger: WEBrick::Log.new(File.open(File::NULL, "w")),
        AccessLog: []
      )

      http.mount_proc("/admin.asp") do |req, res|
        body = req.raw_header.to_s + req.body.to_s

        res.status = 200
        res.content_length = body.size
        res.content_type = 'text/plain'
        res.body = body
      end

      http.mount_proc("/wowee") do |_, res|
        body = "wowee"

        res.status = 200
        res.content_length = body.size
        res.content_type = 'text/plain'
        res.body = body
      end

      trap(:INT) { http.shutdown }
      trap(:TERM) { http.shutdown }
      http.start
    end

    Glint::Server.info[:http_server] = {
      host: "0.0.0.0",
      port: server.port
    }
    server
  end

  before(:all) {
    @server = server
    @server.start
  }

  after(:all) { @server.stop }

  let(:host) { "0.0.0.0" }
  let(:port) { @server.port }
end
