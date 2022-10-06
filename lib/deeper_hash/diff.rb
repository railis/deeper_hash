require "ttyhue"

module DeeperHash
  class Diff
    class Stack
      def initialize
        @stack = []
      end

      def push(value)
        @stack << value
      end

      def pop
        return if @stack.empty?

        @stack = @stack[0..-2]
      end

      def to_a
        @stack
      end
    end

    def initialize(h1, h2)
      @h1 = h1
      @h2 = h2
    end

    def diff
      @diff_stack = Stack.new
      @result = {}
      @attr_change_log = []
      process_diff(@h1, @h2)
      @result
    end

    def process_diff(h1, h2)
      process_diff_pair(h1, h2, :removed_key)
      process_diff_pair(h2, h1, :added_key)
    end

    def process_diff_pair(h1, h2, action)
      h1.each do |k,v|
        next if attribute_change_logged?(k)

        if h2[k]
          if v != h2[k]
            if v.is_a?(Hash) && h2[k].is_a?(Hash)
              @diff_stack.push(k)
              process_diff(v, h2[k])
              @diff_stack.pop
            else
              if v.is_a?(Array) && h2[k].is_a?(Array)
                @result.deep_set(arr_diff(v, h2[k]), *(@diff_stack.to_a + [k, :updated_arr]))
              else
                @result.deep_set({from: v, to: h2[k]}, *(@diff_stack.to_a + [k, :updated_val]))
              end
              log_attribute_change(k)
            end
          end
        else
          dir = @diff_stack.to_a + [action]
          val = (@result.dig(*dir).is_a?(Array) ? @result.dig(*dir) : [])
          val << [k, v]
          @result.deep_set(val, *dir)
          log_attribute_change(k)
        end
      end
    end

    def arr_diff(a1, a2)
      if a1.size == a2.size
        common_1 = a1; common_2 = a2; appended = []; detached = []
      elsif a1.size > a2.size
        if a2.size == 0
          common_1 = []; common_2 = []; appended = []; detached = a1
        else
          common_1 = a1[0..(a2.size-1)]; common_2 = a2; appended = []; detached = a1[a2.size..-1]
        end
      else
        if a1.size == 0
          common_1 = []; common_2 = []; appended = a2; detached = []
        else
          common_1 = a1; common_2 = a2[0..(a1.size-1)]; appended = a2[a1.size..-1]; detached = []
        end
      end
      {}.tap do |res|
        res[:arr] = a1
        res[:appended] = appended unless appended.empty?
        res[:detached] = detached unless detached.empty?
        unless common_1.empty?
          common_1.each_with_index do |v, i|
            val_1 = v
            val_2 = common_2[i]
            if val_1 != val_2
              res[:changed_el] ||= []
              if val_1.is_a?(Array) && val_2.is_a?(Array)
                res[:changed_el] << {updated_arr: arr_diff(val_1, val_2), index: i}
              elsif val_1.is_a?(Hash) && val_2.is_a?(Hash)
                res[:changed_el] << {updated_hash: Diff.new(val_1, val_2).diff, index: i} 
              else
                res[:changed_el] << {from: val_1, to: val_2, index: i}
              end
            end
          end
        end
      end
    end

    def log_attribute_change(attr)
      @attr_change_log << @diff_stack.to_a + [attr]
    end

    def attribute_change_logged?(attr)
      @attr_change_log.include?(@diff_stack.to_a + [attr])
    end

  end
end
