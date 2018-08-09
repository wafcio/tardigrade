
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "tardigrade/version"

Gem::Specification.new do |spec|
  spec.name          = "tardigrade"
  spec.version       = Tardigrade::VERSION
  spec.authors       = ["Krzysztof Wawer"]
  spec.email         = ["krzysztof.wawer@gmail.com"]

  spec.summary       = "Inject method with dependencies"
  spec.homepage      = "https://github.com/wafcio/tardigrade"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "request_store", "~> 1.0.0"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.8.0"
end
