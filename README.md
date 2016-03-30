# Kuaidi100Rails

快递100抓取物流信息推送接口

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kuaidi100_rails'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kuaidi100_rails

## Usage

###抓取物流信息
```ruby
Kuaidi100Rails.POLL_CALLBACK_URL='http://yourserverurl/kuaidis/callback'
Kuaidi100Rails.POLL_KEY = 'yourpollkey'
Kuaidi100Rails.subscribe('yuantong', '7001360xxxx', '北京市', '江苏省镇江市丹阳市',nil,'152xxxxyyyy','company name','product name')
```
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/kuaidi100_rails/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
