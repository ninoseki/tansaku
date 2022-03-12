# frozen_string_literal: true

require "bundler/setup"

require "simplecov"

class InceptionFormatter
  def format(result)
    Coveralls::SimpleCov::Formatter.new.format(result)
  end
end

def setup_formatter
  if ENV['GITHUB_ACTIONS']
    require 'simplecov-lcov'

    SimpleCov::Formatter::LcovFormatter.config do |c|
      c.report_with_single_file = true
      c.single_report_path = 'coverage/lcov.info'
    end
  end

  SimpleCov.formatter =
    if ENV['CI'] || ENV['COVERALLS_REPO_TOKEN']
      if ENV['GITHUB_ACTIONS']
        SimpleCov::Formatter::MultiFormatter.new([InceptionFormatter, SimpleCov::Formatter::LcovFormatter])
      else
        InceptionFormatter
      end
    else
      SimpleCov::Formatter::HTMLFormatter
    end
end

setup_formatter

SimpleCov.start do
  add_filter do |source_file|
    source_file.filename.include?('spec') && !source_file.filename.include?('fixture')
  end
  add_filter %r{/.bundle/}
end

require 'coveralls'

require "tansaku"

require "webmock/rspec"

require_relative "./support/helpers/helper"
require_relative "./support/shared_contexts/http_server_shared_context"

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include Spec::Support::Helpers
end
