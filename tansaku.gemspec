# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "tansaku/version"

Gem::Specification.new do |spec|
  spec.name          = "tansaku"
  spec.version       = Tansaku::VERSION
  spec.authors       = ["Manabu Niseki"]
  spec.email         = ["manabu.niseki@gmail.com"]

  spec.summary       = "Yet another dirbuster tool"
  spec.description   = "Yet another dirbuster tool"
  spec.homepage      = "https://github.com/ninoseki/tansaku"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.3"
  spec.add_development_dependency "coveralls_reborn", "~> 0.24"
  spec.add_development_dependency "glint", "~> 0.1"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.11"
  spec.add_development_dependency "webmock", "~> 3.14"
  spec.add_development_dependency "webrick", "~> 1.7"

  spec.add_dependency "async", "~> 1.30"
  spec.add_dependency "async-http", "~> 0.56"
  spec.add_dependency "thor", "~> 1.2"
end
