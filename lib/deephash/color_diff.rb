require "ttyhue"

module DeepHash
  class ColorDiff

    INDENT_SIZE = 2

    def initialize(h1, h2)
      @diff = Diff.new(h1, h2).diff
    end

    def draw(color_opts = {})
      @color_opts = {
        added: { fg: :gui114 },
        removed: { fg: :gui161 },
        changed: { fg: :gui105 },
        content: { fg: :gui241 }
      }.merge(color_opts)
      @use_indent = true
      @indent = 0
      @result_str = ""
      draw_hash_diff(@diff)
      @indent = 0
      @result_str
    end

    private

    def draw_added_key(k, v)
      @result_str << color_f("{added}#{k}: #{v.inspect}\n", :add)
    end

    def draw_removed_key(k, v)
      @result_str << color_f("{removed}#{k}: #{v.inspect}\n", :delete)
    end

    def draw_changed_value(from, to)
      @result_str << color_f("{removed}#{from.inspect}{/removed} {content}->{/content} {added}#{to.inspect}{/added}\n", :change)
    end

    def draw_hash_diff(diff)
      dup_diff = diff.dup
      deleted = dup_diff.delete(:removed_attr)
      added = dup_diff.delete(:added_attr)
      if changed = dup_diff.delete(:changed_val)
        draw_changed_value(changed[:from], changed[:to])
        @use_indent = true
      end
      if changed_arr = dup_diff.delete(:changed_arr)
        draw_array_diff(changed_arr)
      end
      unless @use_indent
        @result_str << "\n"
        @use_indent = true
      end
      dup_diff.each do |k, v|
        if v[:changed_val] || v[:changed_arr]
          @result_str << color_f("{content}#{k}: ", (:change if v[:changed_val]))
          @use_indent = false
          draw_hash_diff(v)
        else
          @result_str << color_f("{content}#{k}:\n")
          @indent += 1
          draw_hash_diff(v)
          @indent -= 1
        end
      end
      deleted.to_a.each do |k,v|
        draw_removed_key(k, v)
      end
      added.to_a.each do |k,v|
        draw_added_key(k, v)
      end
    end

    def draw_array_diff(changed_arr)
      base_arr =
        if changed_arr[:detached]
          changed_arr[:arr][0..-(changed_arr[:detached].size + 1)]
        else
          changed_arr[:arr]
        end
      @result_str << color_f("{content}[\n")
      @use_indent = true
      @indent += 1
      base_arr.each_with_index do |e, idx|
        change_on_index = changed_arr[:changed_el].to_a.select {|c| c[:index] == idx}.first
        if change_on_index
          if change_on_index[:changed_arr]
            draw_array_diff(change_on_index[:changed_arr])
          elsif change_on_index[:changed_hash]
            @result_str << color_f("{content}{\n")
            @indent += 1
            draw_hash_diff(change_on_index[:changed_hash])
            @indent -= 1
            @result_str << color_f("{content}}\n")
          else
            draw_changed_value(change_on_index[:from], change_on_index[:to])
          end
        else
          @result_str << color_f("{content}#{e.inspect}\n")
        end
      end
      changed_arr[:detached].to_a.each { |e| @result_str << color_f("{removed}#{e.inspect}\n", :delete) }
      changed_arr[:appended].to_a.each { |e| @result_str << color_f("{added}#{e.inspect}\n", :add) }
      @indent -= 1
      @result_str << color_f("{content}]\n")
    end

    def color_f(str, icon = nil)
      icon_str =
        case icon
        when :add
          colorize("{added}+ ")
        when :delete
          colorize("{removed}- ")
        when :change
          colorize("{changed}~ ")
        else
          colorize("{content}. ")
        end
      if @use_indent
        icon_str + (" " * (@indent.to_i * INDENT_SIZE)) + colorize(str)
      else
        colorize(str)
      end
    end

    def colorize(str)
      TTYHue.c(str, @color_opts)
    end

  end
end
