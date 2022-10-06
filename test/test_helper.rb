require "minitest/autorun"
require "minitest/reporters"
require "shoulda-context"

require_relative "../lib/deeper_hash"

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
