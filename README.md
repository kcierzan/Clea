# Clea

Clea (Command Line Email Application) is a simple command line application for sending emails from the console using your gmail account and Ruby's SMTP library. Clea is perfect for getting a quick message out without fumbling with clunky mail clients or web apps.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'clea'
```

And then execute:

    `bundle install`

Or install it yourself as:

    `gem install clea`

## Usage

Ensure the clea executable is in your path and enter 'clea' in the console. Follow the prompts to send your email message. The first time you user clea, clea stores your gmail account information in a pstore file in the gem directory. To reset your information, delete "my-clea-info.pstore".

### Notes:
* As of version 0.8, clea only supports sending from a gmail address.
* You must [enable access for less secure apps](https://www.google.com/settings/security/lesssecureapps) in your google preferences.
* Remember to run `rbenv rehash` to enable the executable if you are using rbenv to manage Ruby installations.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kcierzan/clea.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

