require_relative "test_helper"

describe DeepHash do

  describe "#deep_transform_keys" do

    before do
      @before = {
        a: 1,
        b: {
          c: 2,
          d: {
            e: 3,
            f: 4
          }
        }
      }
      @expected = {
        prefix_a: 1,
        prefix_b: {
          prefix_c: 2,
          prefix_d: {
            prefix_e: 3,
            prefix_f: 4
          }
        }
      }
    end

    should "transform keys recursively" do
      assert_equal @expected, @before.deep_transform_keys {|k| "prefix_#{k}".to_sym}
    end

  end

  describe "#deep_transform_values" do

    before do
      @before = {
        a: 1,
        b: {
          c: 2,
          d: {
            e: 3,
            f: 4
          }
        }
      }
      @expected = {
        a: 11,
        b: {
          c: 12,
          d: {
            e: 13,
            f: 14
          }
        }
      }
    end

    should "transform values recursively" do
      assert_equal @expected, @before.deep_transform_values {|v| v + 10 }
    end

  end

  describe "#deep_select" do

    before do
      @before = {
        a: 1,
        b: 10,
        c: {
          d: 11,
          e: 2,
          f: {
            g: 12,
            h: 4
          },
          i: {
            j: 15
          }
        }
      }
    end

    should "transform hash based on values" do
      expected = {
        b: 10,
        c: {
          d: 11,
          f: { 
            g: 12
          },
          i: {
            j: 15
          }
        }
      }
      assert_equal expected, @before.deep_select {|k,v| v > 9 }
    end

    should "transform hash based on keys" do
      expected = {
        a: 1,
        c: {
          e: 2,
          f: {
            h: 4
          }
        }
      }
      assert_equal expected, @before.deep_select {|k,v| [:a, :e, :h].include?(k) }
    end

  end

  describe "#deep_reject" do

    before do
      @before = {
        a: 1,
        b: 10,
        c: {
          d: 11,
          e: 2,
          f: {
            g: 12,
            h: 4
          },
          i: {
            j: 15
          }
        }
      }
    end

    should "transform hash based on values" do
      expected = {
        a: 1,
        c: {
          e: 2,
          f: {
            h: 4
          }
        }
      }
      assert_equal expected, @before.deep_reject {|k,v| v > 9 }
    end

    should "transform hash based on keys" do
      expected = {
        b: 10,
        c: {
          d: 11,
          f: {
            g: 12,
          },
          i: {
            j: 15
          }
        }
      }
      assert_equal expected, @before.deep_reject {|k,v| [:a, :e, :h].include?(k) }
    end

  end

  describe "#deep_merge" do

    before do
      @to_merge = {
        a: 1,
        b: {
          c: 2,
          d: {
            e: 3,
            f: 4,
            j: 21
          }
        },
        h: 22
      }
    end

    should "recursively merge values into empty hash" do
      assert_equal @to_merge, {}.deep_merge(@to_merge)
    end

    should "recursively update values" do
      before = {
        a: 10,
        b: {
          c: 12,
          g: 18,
          d: {
            e: 13,
            f: 14,
            h: 19
          }
        },
        i: 20
      }
      expected = {
        a: 1,
        b: {
          c: 2,
          g: 18,
          d: {
            e: 3,
            f: 4,
            h: 19,
            j: 21
          }
        },
        i: 20,
        h: 22
      }
      assert_equal expected, before.deep_merge(@to_merge)
    end

  end

  describe "#deep_include?" do

    before do
      @hash = {
        a: 1,
        b: {
          c: 2,
          d: {
            e: 3,
            f: 4,
            j: 21
          }
        },
        h: 22
      }
    end

    should "return true when has is recursively included" do
      assert_equal true, @hash.deep_include?({a: 1})
      assert_equal true, @hash.deep_include?({a: 1, b: { c: 2 }})
      assert_equal true, @hash.deep_include?({h: 22, b: { c: 2, d: {f: 4} }})
      assert_equal false, @hash.deep_include?({a: 2})
      assert_equal false, @hash.deep_include?({a: 1, b: { c: 3 }})
      assert_equal false, @hash.deep_include?({h: 22, b: { c: 2, d: {f: 5} }})
    end

  end

  describe "#deep_set" do

    before do
      @hash = {
        a: 1,
        b: {
          c: 2,
          d: {
            e: 3,
            f: 4
          }
        }
      }
    end

    should "add new value to empty hash" do
      hash = {}
      expected = {a: 1}
      hash.deep_set(1, :a)
      assert_equal expected, hash
    end

    should "add new value recursively to empty hash" do
      hash = {}
      expected = {a: {b: {c: 1}}}
      hash.deep_set(1, :a, :b, :c)
      assert_equal expected, hash
    end

    should "update value recursively in non empty hash" do
      hash = {
        a: 1,
        b: {
          c: 2,
          e: 3
        }
      }
      expected = {
        a: 1,
        b: {
          c: 2,
          e: 5
        }
      }
      hash.deep_set(5, :b, :e)
      assert_equal expected, hash
    end

  end

  describe "#diff" do
  end

end
