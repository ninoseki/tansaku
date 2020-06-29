# frozen_string_literal: true

require "cgi"
require "net/http"
require "parallel"
require "uri"

module Tansaku
  class Crawler
    DEFAULT_USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36"

    attr_reader :base_uri

    attr_reader :additional_list
    attr_reader :host
    attr_reader :threads
    attr_reader :type
    attr_reader :user_agent

    def initialize(
      base_uri,
      additional_list: nil,
      host: nil,
      threads: Parallel.processor_count,
      type: "all",
      user_agent: DEFAULT_USER_AGENT
    )
      @base_uri = URI.parse(base_uri)
      raise ArgumentError, "Invalid URI" unless valid_uri?

      @additional_list = additional_list
      unless additional_list.nil?
        raise ArgumentError, "Invalid path" unless valid_path?
      end

      @host = host
      @threads = threads
      @type = type
      @user_agent = user_agent
    end

    def online?(url)
      res = head(url)
      [200, 401, 302].include? res.code.to_i
    end

    def crawl
      results = Parallel.map(urls, in_threads: threads) do |url|
        url if online?(url)
      rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => _e
        nil
      end
      results.compact
    end

    private

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

    def request(req)
      Net::HTTP.start(base_uri.host, base_uri.port) { |http| http.request(req) }
    end

    def head(url)
      head = Net::HTTP::Head.new(url)
      head["User-Agent"] = user_agent
      head["Host"] = host unless host.nil?

      request(head)
    end
  end
end
