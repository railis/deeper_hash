# frozen_string_literal: true

require_relative "lib/deeper_hash/version"

Gem::Specification.new do |spec|
  spec.name = "deeper_hash"
  spec.version = DeeperHash::VERSION
  spec.authors = ["Dominik Sito"]
  spec.email = ["dominik.sito@gmail.com"]

  spec.summary = "Set of utility methods for vanilia ruby Hash providing a way of handling, transforming, diffing it in a Tree-like manner."
  spec.description = "Set of utility methods for vanilia ruby Hash providing a way of handling, transforming, diffing it in a Tree-like manner."
  spec.homepage = "https://github.com/railis/deephash"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://raw.githubusercontent.com/railis/deephash/master/CHANGELOG.md"

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.require_paths = ["lib"]

  spec.add_dependency "ttyhue", "~> 0.1.2"
  spec.add_development_dependency "minitest", "5.16.3"
  spec.add_development_dependency "minitest-reporters", "1.5.0"
  spec.add_development_dependency "shoulda-context", "2.0.0"
end
