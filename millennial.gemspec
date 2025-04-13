# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "birusupi-theme"
  spec.version       = "2.0.0"
  spec.authors       = ["Birusupi"]
  spec.email         = ["moosapporo@gmail.com"]

  spec.summary       = "A customized Jekyll theme based on Millennial"
  spec.homepage      = "https://github.com/spira-unplugged/birusupi"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").select { |f| f.match(%r!^(assets|_layouts|_includes|_sass|LICENSE|README|CHANGELOG)!i) }

  spec.add_runtime_dependency "jekyll", "~> 4.2"
  spec.add_runtime_dependency "jekyll-feed", "~> 0.6"
  spec.add_runtime_dependency "jekyll-paginate", "~> 1.1"
  spec.add_runtime_dependency "jekyll-sitemap", "~> 1.3"
  spec.add_runtime_dependency "jekyll-seo-tag", "~> 2.6"
end
