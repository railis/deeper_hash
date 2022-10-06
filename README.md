# DeepHash

Set of utility methods for vanilia ruby `Hash` providing a way of handling, transforming, diffing it in a Tree-like manner. 

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add deephash

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install deephash

## Usage

```ruby
require 'deephash'
```

## Methods

### #deep_include?

Same as `Hash#include?` but fully recursive:

```ruby
hash = {
  a: 1,
  b: {
    c: 1,
    d: 2
  }
}

hash.deep_include?(a: 1, b: { c: 1 }) #=> true
hash.deep_include?(a: 1, b: { c: 2 }) #=> false

```

### #deep_merge

Adding or replacing both root and nested values:

```ruby
hash = {
  a: 1,
  b: 2,
  c: {
    d: 1,
    e: 2
  }
}

hash.deep_merge(
  b: 3,
  c: {
    e: 4,
    f: 5
  }
)
#  #=> {
#    a: 1,
#    b: 3,
#    c: {
#      d: 1,
#      e: 4,
#      f: 5
#    }
#  }
```

### #deep_select

Filtering `Hash` based on key/value pairs with non-hash values:

```ruby
hash = {
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

hash.deep_select { |k,v| [:a, :e, :h].include?(k) }
#  #=> {
#    a: 1,
#    c: {
#      e: 2,
#      f: {
#        h: 4
#      }
#    }
#  }

hash.deep_select { |k,v| v > 9 }
#  #=> {
#    b: 10,
#    c: {
#      d: 11,
#      f: { 
#        g: 12
#      },
#      i: {
#        j: 15
#      }
#    }
#  }
```

### #deep_reject

Inverse of `#deep_select`

### #deep_transform_keys

Same as `Hash#transform_keys` but fully recursive:

```ruby
hash = {
  a: 1,
  b: {
    c: 2,
    d: 3
  }
}

hash.deep_transform_keys { |k| "prefix_#{k}".to_sym }
#  #=> {
#    prefix_a: 1,
#    prefix_b: {
#      prefix_c: 2,
#      prefix_d: 3
#    }
#  }
```

### #deep_transform_values

Same as `Hash#transform_values` but fully recursive:

```ruby
hash = {
  a: 1,
  b: {
    c: 2,
    d: 3
  }
}

hash.deep_transform_values { |k,v| v + 10 }
#  #=> {
#    a: 10,
#    b: {
#      c: 12,
#      d: 13
#    }
#  }
```

## Diffing

### #diff

Presents difference between two hashes at any level returning `Hash` object with all changes.

### #draw_diff

Returns the diff as git-like colored string.

```ruby
hash1 = {
  foo: "bar",
  fiz: "biz",
  fez: "cez",
  a: {
    b: 10,
    c: 2
  }
}

hash2 = {
  foo: "bar",
  fiz: "biz",
  faz: "caz",
  a: {
    b: 1,
    c: 2,
    d: 12
  }
}

hash1.diff(hash2)
#  #=> {
#    :removed_key=>[[:fez, "cez"]],
#    :added_key=>[[:faz, "caz"]],
#    :a=>{
#      :b=>{ :updated_val=>{:from=>10, :to=>1} },
#      :added_key=>[[:d, 12]]
#    }
#  }

puts hash1.draw_diff(hash2)
```
![screenshot](https://raw.githubusercontent.com/railis/deephash/master/examples/example1.png)

Also works with `Array` values:

```ruby
hash1 = {
  foo: "bar",
  fiz: [1, 2, 3]
}

hash2 = {
  foo: "bar",
  fiz: [2, 2, 3, 4]
}

hash1.diff(hash2)
#  #=> {
#    :fiz=>{
#      :updated_arr=>{
#        :arr=>[1, 2, 3],
#        :appended=>[4],
#        :changed_el=>[{:from=>1, :to=>2, :index=>0}]
#      }
#    }
#  }

puts hash1.draw_diff(hash2)
```
![screenshot](https://raw.githubusercontent.com/railis/deephash/master/examples/example2.png)

The diff can traverse across entire `Hash` until reaching deepest level. Eg: `Array` values with `Hash` elements, containing other `Arrays` and `Hashes`:

```ruby
hash1 = {
  foo: "bar",
  fiz: [
    1,
    {
      a: 1,
      b: [
        "alpha",
        "beta"
      ]
    },
    3
  ]
}

hash2 = {
  foo: "bar",
  fiz: [
    2,
    {
      a: 2,
      b: [
        "alpha",
        "betav2",
        "gamma"
      ]
    },
    3
  ]
}

hash1.diff(hash2)
#  #=> {
#    :fiz=>{
#      :updated_arr=>{
#        :arr=>[1,{:a=>1,:b=>["alpha","beta"]}, 3],
#        :changed_el=>[
#          {
#            :from=>1,
#            :to=>2,
#            :index=>0
#          },
#          {
#            :updated_hash=>{
#              :a=>{:updated_val=>{:from=>1, :to=>2}},
#              :b=>{
#                :updated_arr=>{
#                  :arr=>["alpha", "beta"],
#                  :appended=>["gamma"],
#                  :changed_el=>[
#                    {:from=>"beta", :to=>"betav2", :index=>1}
#                  ]
#                }
#              }
#            },
#            :index=>1
#          }
#        ]
#      }
#    }
#  }

puts hash1.draw_diff(hash2)
```
![screenshot](https://raw.githubusercontent.com/railis/deephash/master/examples/example3.png)

Diff output color can be formatted by overwriting styles: `content` `added` `removed` `changed`, eg:
```ruby
puts hash1.draw_diff(hash2, content: { fg: :white }, added: { fg: :lblue })
```

For more information about using styles and available color options, see [TTYHue](https://github.com/railis/ttyhue) ruby gem.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/railis/deephash). This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/deephash/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Deephash project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/deephash/blob/master/CODE_OF_CONDUCT.md).
