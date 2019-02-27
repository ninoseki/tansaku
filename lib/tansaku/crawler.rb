# frozen_string_literal: true

require "cgi"
require "net/http"
require "parallel"
require "uri"

module Tansaku
  class Crawler
    DEFAULT_USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.79 Safari/537.36 Edge/14.14393"

    attr_reader :base_uri
    attr_reader :additional_list, :threads, :user_agent

    def initialize(base_uri, additional_list: nil, threads: 10, user_agent: DEFAULT_USER_AGENT)
      @base_uri = URI.parse(base_uri)
      raise ArgumentError, "Invalid URI" unless valid_uri?

      @additional_list = additional_list
      unless additional_list.nil?
        raise ArgumentError, "Invalid path" unless valid_path?
      end

      @threads = threads
      @user_agent = user_agent
    end

    def online?(url)
      res = head(url)
      [200, 401, 302].include? res.code.to_i
    end

    def crawl
      results = Parallel.map(urls, in_threads: threads) do |url|
        url if online?(url)
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
      paths = File.readlines(File.expand_path("./fixtures/paths.txt", __dir__))
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
      request(head)
    end
  end
end
