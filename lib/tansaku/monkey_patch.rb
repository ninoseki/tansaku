# frozen_string_literal: true

require "protocol/http1/connection"

module Protocol
  module HTTP1
    class Connection
      def write_request(authority, method, path, version, headers)
        host = authority
        if headers.include?("host")
          host = headers["host"]
          headers.delete "host"
        end

        @stream.write("#{method} #{path} #{version}\r\n")
        @stream.write("host: #{host}\r\n")

        write_headers(headers)
      end
    end
  end
end
