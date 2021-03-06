
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "library_assistant/version"

Gem::Specification.new do |spec|
  spec.name          = "library_assistant"
  spec.version       = LibraryAssistant::VERSION
  spec.authors       = ["Maloney L."]
  spec.email         = ["maloneyl@users.noreply.github.com"]

  spec.summary       = "A gem that grabs books from a Goodreads shelf and finds them in the Islington Library"
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/maloneyl/library_assistant"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = ""
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "factory_bot", "~> 4.0"
  spec.add_development_dependency "faker", "~> 1.8"
  spec.add_development_dependency "pry-byebug", "~> 3.6"

  spec.add_runtime_dependency "dotenv", "~> 2.2"
  spec.add_runtime_dependency "addressable", "~> 2.5"
  spec.add_runtime_dependency "nokogiri", "~> 1.8"
  spec.add_runtime_dependency "goodreads", "~> 0.6"
  spec.add_runtime_dependency "fuzzy-string-match", "~> 1.0"
end
