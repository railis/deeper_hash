module DeepHash
  class Meta

    class << self

      def transform_keys(hash, &block)
        transform(hash, include_hash_values: true) do |k, v, h|
          h[block.call(k)] = v
        end
      end

      def transform_values(hash, &block)
        transform(hash) do |k, v, h|
          h[k] = block.call(v) unless v.is_a?(Hash)
        end
      end

      def select(hash, &block)
        transform(hash) do |k, v, h|
          h[k] = v if block.call(k,v)
        end
      end

      def reject(hash, &block)
        transform(hash) do |k, v, h|
          h[k] = v unless block.call(k,v)
        end
      end

      def merge(hash, other_hash)
        hash.dup.tap do |h|
          other_hash.each do |k, v|
            if h[k].is_a?(Hash) && v.is_a?(Hash)
              h[k] = merge(h[k], v)
            else
              h[k] = v
            end
          end
        end
      end

      def include?(hash, other_hash)
        return true if hash == other_hash

        other_hash.each do |k, v|
          if hash[k].is_a?(Hash) && v.is_a?(Hash)
            return false unless include?(hash[k], v)
          else
            return false unless hash[k] == v
          end
        end
        true
      end

      def set(hash, value, keys)
        keys[0..-2].inject(hash) do |acc, e|
          acc[e] ||= {}
        end[keys.last] = value
      end

      private

      def transform(hash, opts = {}, &block)
        {}.tap do |new_hash|
          hash.each do |k,v|
            case v
            when Hash
              nested_hash = transform(v, opts, &block)
              if opts[:include_hash_values]
                block.call(k, nested_hash, new_hash)
              else
                new_hash[k] = nested_hash unless nested_hash.empty?
              end
            else
              block.call(k, v, new_hash)
            end
          end
        end
      end

    end

  end
end
