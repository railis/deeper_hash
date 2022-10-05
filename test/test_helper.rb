require "minitest/autorun"
require "minitest/reporters"
require "shoulda-context"

require_relative "../lib/deephash"

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
