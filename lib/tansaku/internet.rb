# frozen_string_literal: true

require "async/http/internet"

module Tansaku
  class Internet < Async::HTTP::Internet
    def call(method, url_or_endpoint, headers = nil, body = nil)
      endpoint = if url_or_endpoint.is_a?(Async::HTTP::Endpoint)
                   url_or_endpoint
                 else
                   Async::HTTP::Endpoint.parse(url_or_endpoint)
                 end
      key = host_key(endpoint)

      client = @clients.fetch(key) do
        @clients[key] = client_for(endpoint)
      end

      body = Async::HTTP::Body::Buffered.wrap(body)
      headers = ::Protocol::HTTP::Headers[headers]

      request = ::Protocol::HTTP::Request.new(endpoint.scheme, endpoint.authority, method, endpoint.path, nil, headers, body)

      client.call(request)
    end

    ::Protocol::HTTP::Methods.each do |_name, verb|
      define_method(verb.downcase) do |url_or_endpoint, headers = nil, body = nil|
        url_or_endpoint = url_or_endpoint.to_str unless url_or_endpoint.is_a?(Async::HTTP::Endpoint)
        call(verb, url_or_endpoint, headers, body)
      end
    end
  end
end
