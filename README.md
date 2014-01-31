# LogmanRails

This is Rails client library for [Logman](https://github.com/saicoder/logman). 
Library tracks exceptions in Rails and sends them 
to [Logman](https://github.com/saicoder/logman) endpoint.

## Installation

Add this line to your application's Gemfile:

    gem 'logman_rails'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install logman_rails

## Usage

Place following code in your environment config with your endpoint and token:
```ruby
config.middleware.use Logman::Rails,
      :endpoint=> 'http://endpoint.location.com/',
      :token=> 'your bucket token'
```

You can also send custom logs with methods below:
```ruby
Logman.info 'Some message'
Logman.success 'File uploaded', {optional: 'data'}
```
Available methods are: `error`, `warn`, `success`, `info`

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
