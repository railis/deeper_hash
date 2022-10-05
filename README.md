# DeepHash

Set of utility methods for vanilia ruby `Hash` providing a set of recursive operations.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add deephash

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install deephash

## Usage

```ruby
require 'deephash'
```

### Methods

### #deep_include?

Same as `Hash#include?` but at recursive level:

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

Same as `Hash#transform_keys` but on recursive level:

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

Same as `Hash#transform_values` but on recursive level:

```ruby
hash = {
  a: 1,
  b: {
    c: 2,
    d: 3
  }
}

hash.transform_values { |k,v| v + 10 }
#  #=> {
#    a: 1,
#    b: {
#      c: 2,
#      d: 3
#    }
#  }
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/deephash. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/deephash/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Deephash project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/deephash/blob/master/CODE_OF_CONDUCT.md).
