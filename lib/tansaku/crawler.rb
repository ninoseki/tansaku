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

    # @return [String]
    attr_reader :base_uri

    attr_reader :additional_list

    # @return [Integer]
    attr_reader :max_concurrent_requests

    # @return [String]
    attr_reader :type

    # @return [String]
    attr_reader :method

    # @return [String, nil]
    attr_reader :body

    # @return [Float, nil]
    attr_reader :timeout

    def initialize(
      base_uri,
      additional_list: nil,
      headers: {},
      method: "HEAD",
      body: nil,
      timeout: nil,
      max_concurrent_requests: nil,
      type: "all"
    )
      @base_uri = URI.parse(base_uri.downcase)
      raise ArgumentError, "Invalid URI" unless valid_uri?

      @additional_list = additional_list
      raise ArgumentError, "Invalid path" if !additional_list.nil? && !valid_path?

      @method = method.upcase
      raise ArgumentError, "Invalid HTTP method" unless valid_method?

      @headers = headers
      @body = body

      @timeout = timeout.nil? ? nil : timeout.to_f

      @max_concurrent_requests = max_concurrent_requests || (Etc.nprocessors * 8)
      @type = type
    end

    def crawl
      results = {}

      Async do |task|
        barrier = Async::Barrier.new
        semaphore = Async::Semaphore.new(max_concurrent_requests, parent: barrier)
        internet = Async::HTTP::Internet.new

        paths.each do |path|
          semaphore.async do
            url = url_for(path)

            res = dispatch_http_request(task, internet, url)
            next unless online?(res.status)

            log = [method, url, res.status].join(",")
            Tansaku.logger.info(log)

            results[url] = res.status
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

    def valid_method?
      Protocol::HTTP::Methods.valid? method
    end

    def paths
      paths = Path.get_by_type(type)
      paths += File.readlines(File.expand_path(additional_list, __dir__)) if additional_list
      paths.filter_map(&:chomp)
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

    #
    # Dispatch an HTTP request
    #
    # @param [Async::Task] task
    # @param [Async::HTTP::Internet] internet
    # @param [String] url
    #
    # @return [Async::HTTP::Protocol::Response]
    #
    def dispatch_http_request(task, internet, url)
      return internet.call(method, url, request_headers, body) if timeout.nil?

      task.with_timeout(timeout) do
        internet.call(method, url, request_headers, body)
      end
    end
  end
end
