# frozen_string_literal: true

require "tansaku/version"

require "tansaku/internet"
require "tansaku/path"

require "tansaku/crawler"

require "tansaku/cli"

require "memist"
require "semantic_logger"

module Tansaku
  class << self
    include Memist::Memoizable

    def logger
      SemanticLogger.default_level = :info
      SemanticLogger.add_appender(io: $stderr, formatter: :color)
      SemanticLogger["Tansaku"]
    end
    memoize :logger
  end
end
