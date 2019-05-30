# frozen_string_literal: true

module Tansaku
  class Path
    def self.get_by_type(type)
      new.get_by_type(type)
    end

    def get_by_type(type)
      raise ArgumentError, "Invalid type is given. #{type} is not supported." unless valid_type?(type)

      return all if type == "all"

      File.readlines(File.expand_path("./lists/#{type}.txt", __dir__))
    end

    private

    def all
      types.map { |type| get_by_type(type) }.flatten
    end

    def types
      @types = Dir.glob(File.expand_path("./lists/*.txt", __dir__)).map do |path|
        File.basename(path).split(".").first
      end
    end

    def valid_type?(type)
      return true if type == "all"

      types.include? type
    end
  end
end
