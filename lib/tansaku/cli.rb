require "thor"

require "json"

module Tansaku
  class CLI < Thor
    desc "crawl URL", "Crawl a given URL"
    method_option :additional_list, desc: "Path to the additonal crawling pats file"
    method_option :threads, type: :numeric, desc: "Number of threads to use"
    method_option :user_agent, type: :string, desc: "User-Agent parameter to use"
    def crawl(url)
      params = options.compact.map { |k, v| [k.to_sym, v] }.to_h
      crawler = Crawler.new(url, params)
      results = crawler.crawl
      puts results.to_json
    end
  end
end
