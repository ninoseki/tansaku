# frozen_string_literal: true

require "thor"

require "json"

module Tansaku
  class CLI < Thor
    desc "crawl URL", "Crawl a given URL"
    method_option :type, desc: "Type of a list to crawl (admin, backup, database, etc, log or all)", default: "all"
    method_option :additional_list, desc: "Path to the file which includes additonal paths to crawl"
    method_option :threads, type: :numeric, desc: "Number of threads to use"
    method_option :user_agent, type: :string, desc: "User-Agent parameter to use"
    def crawl(url)
      params = options.compact.map { |k, v| [k.to_sym, v] }.to_h
      begin
        crawler = Crawler.new(url, **params)
        results = crawler.crawl
        puts results.to_json
      rescue ArgumentError => e
        puts e
      end
    end
  end
end
