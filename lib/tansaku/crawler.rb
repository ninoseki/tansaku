# frozen_string_literal: true

require "async/http/internet"
require "async"
require "async/barrier"
require "async/semaphore"
require "cgi"
require "etc"
require "uri"

require "tansaku/monkey_patch"

module Tansaku
  class Crawler
    DEFAULT_USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36"

    attr_reader :base_uri, :additional_list, :max_concurrent_requests, :type

    def initialize(
      base_uri,
      additional_list: nil,
      headers: {},
      max_concurrent_requests: nil,
      type: "all"
    )
      @base_uri = URI.parse(base_uri)
      raise ArgumentError, "Invalid URI" unless valid_uri?

      @additional_list = additional_list
      raise ArgumentError, "Invalid path" if !additional_list.nil? && !valid_path?

      @headers = headers
      @max_concurrent_requests = max_concurrent_requests || (Etc.nprocessors * 8)
      @type = type
    end

    def crawl
      results = {}
      Async do
        barrier = Async::Barrier.new
        semaphore = Async::Semaphore.new(max_concurrent_requests, parent: barrier)
        internet = Async::HTTP::Internet.new

        paths.each do |path|
          semaphore.async do
            url = url_for(path)
            res = internet.head(url, request_headers)

            results[url] = res.status if online?(res.status)
          rescue Errno::ECONNRESET, Errno::ECONNREFUSED, Errno::EHOSTUNREACH, EOFError, OpenSSL::SSL::SSLError, Async::TimeoutError
            next
          end
        end
        barrier.wait
      end
      results
    end

    private

    def online?(status)
      [200, 204, 301, 302, 307, 401, 403].include? status.to_i
    end

    def valid_uri?
      ["http", "https"].include? base_uri.scheme
    end

    def valid_path?
      File.exist?(additional_list)
    end

    def paths
      paths = Path.get_by_type(type)
      paths += File.readlines(File.expand_path(additional_list, __dir__)) if additional_list
      paths.map(&:chomp).compact
    end

    def url_for(path)
      URI(base_uri + CGI.escape(path)).to_s
    end

    def urls
      paths.map { |path| url_for path }
    end

    def request_headers
      @request_headers ||= @headers.tap do |headers|
        upcase_keys = headers.keys.map(&:downcase).map(&:to_s)
        headers["user-agent"] = DEFAULT_USER_AGENT unless upcase_keys.include?("user-agent")
      end.compact
    end
  end
end
