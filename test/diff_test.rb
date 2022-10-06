require_relative "test_helper"

describe DeepHash do

  def assert_diff(h1, h2, expected)
    assert_equal expected, h1.diff(h2) 
  end

  describe "#diff" do

    context "base attributes" do

      should "return diff when attribute is added" do
        assert_diff(
          { foo: "bar" },
          { foo: "bar", fiz: "biz" },
          { added_key: [[:fiz, "biz"]] }
        )
        assert_diff(
          { foo: "bar", boo: "aar" },
          { foo: "bar", boo: "aar", fiz: "bizz", ciz: "aizz" },
          { added_key: [[:fiz, "bizz"], [:ciz, "aizz"]] }
        )
      end

      should "return diff when attribute is removed" do
        assert_diff(
          { foo: "bar", fiz: "bizz" },
          { foo: "bar" },
          { removed_key: [[:fiz, "bizz"]] }
        )
        assert_diff(
          { foo: "bar", boo: "aar", fiz: "bizz", ciz: "aizz" },
          { foo: "bar", boo: "aar" },
          { removed_key: [[:fiz, "bizz"], [:ciz, "aizz"]] }
        )
      end

      should "return diff when attribute is changed" do
        assert_diff(
          { foo: "bar", fiz: "bizz" },
          { foo: "bar", fiz: "bezz" },
          { fiz: { updated_val: { from: "bizz", to: "bezz" } } }
        )
        assert_diff(
          { foo: "bar", fiz: "bizz", cez: "zez" },
          { foo: "bar", fiz: "bezz", cez: "aez" },
          {
            fiz: { updated_val: { from: "bizz", to: "bezz" } },
            cez: { updated_val: { from: "zez", to: "aez" } }
          }
        )
      end

    end

    context "nested attributes" do

      should "return diff when attribute is added" do
        assert_diff(
          { alpha: { foo: "bar" } },
          { alpha: { foo: "bar", fiz: "biz" } },
          { alpha: { added_key: [[:fiz, "biz"]] } }
        )
        assert_diff(
          { alpha: { foo: "bar", boo: "aar" } },
          { alpha: { foo: "bar", boo: "aar", fiz: "biz", ciz: "aizz" } },
          { alpha: { added_key: [[:fiz, "biz"], [:ciz, "aizz"]] } }
        )
      end

      should "return diff when attribute is removed" do
        assert_diff(
          { alpha: { foo: "bar", fiz: "bizz" } },
          { alpha: { foo: "bar" } },
          { alpha: { removed_key: [[:fiz, "bizz"]] } }
        )
        assert_diff(
          { alpha: { foo: "bar", boo: "aar", fiz: "biz", ciz: "aizz" } },
          { alpha: { foo: "bar", boo: "aar" } },
          { alpha: { removed_key: [[:fiz, "biz"], [:ciz, "aizz"]] } }
        )
      end

      should "return diff when attribute is changed" do
        assert_diff(
          { alpha: { foo: "bar", fiz: "bizz" } },
          { alpha: { foo: "bar", fiz: "bezz" } },
          { alpha: { fiz: { updated_val: { from: "bizz", to: "bezz" } } } }
        )
      end

    end

    context "array values" do

      should "return diff when element is appended" do
        assert_diff(
          { foo: "bar", fiz: ["aaa", "bbb"] },
          { foo: "bar", fiz: ["aaa", "bbb", "ccc"] },
          { fiz: { updated_arr: { arr: ["aaa", "bbb"], appended: ["ccc"] } } }
        )
        assert_diff(
          { foo: "bar", fiz: ["aaa", "bbb"] },
          { foo: "bar", fiz: ["aaa", "bbb", "ccc", "ddd"] },
          { fiz: { updated_arr: { arr: ["aaa", "bbb"], appended: ["ccc", "ddd"] } } }
        )
      end

      should "return diff when element is detached" do
        assert_diff(
          { foo: "bar", fiz: ["aaa", "bbb", "ccc"] },
          { foo: "bar", fiz: ["aaa", "bbb"] },
          { fiz: { updated_arr: { arr: ["aaa", "bbb", "ccc"], detached: ["ccc"] } } }
        )
        assert_diff(
          { foo: "bar", fiz: ["aaa", "bbb", "ccc", "ddd"] },
          { foo: "bar", fiz: ["aaa", "bbb"] },
          { fiz: { updated_arr: { arr: ["aaa", "bbb", "ccc", "ddd"], detached: ["ccc", "ddd"] } } }
        )
      end

      should "return diff when elements are changed" do
        assert_diff(
          { foo: "bar", fiz: ["aaa", "bbb"] },
          { foo: "bar", fiz: ["aaa", "ccc"] },
          { fiz: { updated_arr: { arr: ["aaa", "bbb"], changed_el: [{from: "bbb", to: "ccc", index: 1}] } } }
        )
        assert_diff(
          { foo: "bar", fiz: ["aaa", "bbb", "ccc"] },
          { foo: "bar", fiz: ["zzz", "bbb", "xxx"] },
          { fiz: { updated_arr: { arr: ["aaa", "bbb", "ccc"], changed_el: [{from: "aaa", to: "zzz", index: 0}, {from: "ccc", to: "xxx", index: 2}] } } }
        )
      end

      should "return diff when elements changed and appended/detached" do
        assert_diff(
          { foo: "bar", fiz: ["aaa", "bbb"] },
          { foo: "bar", fiz: ["zzz", "bbb", "ccc"] },
          { fiz: { updated_arr: { arr: ["aaa", "bbb"], changed_el: [{from: "aaa", to: "zzz", index: 0}], appended: ["ccc"] } } }
        )
        assert_diff(
          { foo: "bar", fiz: ["zzz", "bbb", "ccc"] },
          { foo: "bar", fiz: ["aaa", "bbb"] },
          { fiz: { updated_arr: { arr: ["zzz", "bbb", "ccc"], changed_el: [{from: "zzz", to: "aaa", index: 0}], detached: ["ccc"] } } }
        )
      end

      should "return diff for nested arrays" do
        assert_diff(
          { foo: "bar", fiz: [["aaa", "bbb"], ["ccc", "ddd"]] },
          { foo: "bar", fiz: [["aaa", "zzz"], ["ccc", "ddd", "eee"]] },
          {
            fiz: {
              updated_arr: {
                arr: [["aaa", "bbb"], ["ccc", "ddd"]],
                changed_el: [
                  { updated_arr: { arr: ["aaa", "bbb"], changed_el: [{from: "bbb", to: "zzz", index: 1}] }, index: 0 },
                  { updated_arr: { arr: ["ccc", "ddd"], appended: ["eee"] }, index: 1 }
                ]
              }
            }
          }
        )
      end

      should "return diff for hashes in arrays" do
        assert_diff(
          { foo: "bar", fiz: ["aaa", { bbb: "ccc" }]},
          { foo: "bar", fiz: ["aaa", { bbb: "ddd" }]},
          {
            fiz: {
              updated_arr: {
                arr: ["aaa", { bbb: "ccc" }],
                changed_el: [
                  { updated_hash: { bbb: { updated_val: { from: "ccc", to: "ddd" } } }, index: 1 }
                ]
              }
            }
          }
        )
      end

    end

  end

end
