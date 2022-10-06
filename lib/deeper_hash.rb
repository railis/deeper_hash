# frozen_string_literal: true

require_relative "deeper_hash/version"
require_relative "deeper_hash/meta"
require_relative "deeper_hash/diff"
require_relative "deeper_hash/color_diff"

module DeeperHash

  %w[
    transform_keys
    transform_values
    select
    reject
  ].each do |method|
    define_method "deep_#{method}" do |&block|
      Meta.send(method, self, &block)
    end
  end

  %w[
    merge
    include?
  ].each do |method|
    define_method "deep_#{method}" do |value|
      Meta.send(method, self, value)
    end
  end

  def deep_set(value, *keys)
    Meta.set(self, value, keys)
  end

  def diff(other_hash)
    Diff.new(self, other_hash).diff
  end

  def draw_diff(other_hash, styles = {})
    ColorDiff.new(self, other_hash).draw(styles)
  end

end

Hash.send :include, DeeperHash
