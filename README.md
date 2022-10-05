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

### .deep_include?

Same as `Hash#include?` but at recursive level:

```ruby
{ a: 1, b: { c: 1, d: 2} }.deep_include?(a: 1, b: { c: 1 }) #=> true
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
