# frozen_string_literal: true

require_relative "lib/orthoses/paranoia/version"

Gem::Specification.new do |spec|
  spec.name = "orthoses-paranoia"
  spec.version = Orthoses::Paranoia::VERSION
  spec.authors = ["ksss"]
  spec.email = ["co000ri@gmail.com"]

  spec.summary = "Orthoses middleware for paranoia"
  spec.description = "Orthoses middleware paranoia"
  spec.homepage = "https://github.com/ksss/orthoses-paranoia"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    [
      %w[CODE_OF_CONDUCT.md LICENSE.txt README.md],
      Dir.glob("lib/**/*.*").grep_v(/_test\.rb\z/)
    ].flatten
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "orthoses", ">= 1.13"
  spec.add_dependency "paranoia"
  spec.metadata["rubygems_mfa_required"] = "true"
end
