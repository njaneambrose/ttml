
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ttml/version"

Gem::Specification.new do |spec|
  spec.name          = "ttml"
  spec.version       = Ttml::VERSION
  spec.authors       = ["njaneambrose"]
  spec.email         = ["njaneambrose@gmail.com"]

  spec.summary       = %q{A lightweight language that compiles to Markup}
  spec.description   = %q{TTML is a markup generating language that can be used to produce any markup from HTMl,XHTML,XML and many more.
  TTML also has extended features like shortcuts and imports that can be used to generate Markup for web projects}
  spec.homepage      = "https://github.com/njaneambrose/ttml"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|docs)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
