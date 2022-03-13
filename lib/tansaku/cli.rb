# frozen_string_literal: true

require "thor"

require "json"

module Tansaku
  class CLI < Thor
    desc "crawl URL", "Crawl a given URL"
    method_option :additional_list, desc: "Path to the file which includes additional paths to crawl"
    method_option :headers, type: :hash, default: {}, desc: "HTTP headers to use"
    method_option :method, type: :string, default: "HEAD", desc: "HTTP method to use"
    method_option :body, type: :string, required: false, default: nil, desc: "HTTP reqeust body to use"
    method_option :max_concurrent_requests, type: :numeric, desc: "Number of concurrent requests to use"
    method_option :type, desc: "Type of a list to crawl (admin, backup, database, etc, log or all)", default: "all"
    def crawl(url)
      params = options.compact.transform_keys(&:to_sym)
      begin
        crawler = Crawler.new(url, **params)
        results = crawler.crawl
        puts results.to_json
      rescue ArgumentError => e
        puts e
      end
    end

    default_command :crawl

    class << self
      def exit_on_failure?
        true
      end
    end
  end
end
