# Rack::Konami

Rack::Konami is a Rack middleware that injects a hidden snippet into your pages.
When a user enters the Konami Code (\u2191 \u2191 \u2193 \u2193 \u2190 \u2192 \u2190 \u2192 B A \u21B5), the
snippet fades in and then disappears after a configurable delay.

## Features

* Works with jQuery 1.4 or later, falling back to vanilla JavaScript if jQuery isn't present.
* Supports both keyboard and touch devices.
* Configurable HTML snippet and fade-out delay.
* Automatically updates the `Content-Length` header when injecting content.
* Compatible with Ruby 3 and Rack 3.

## Installation

```bash
gem install rack_konami
```

## Basic Usage

```ruby
require 'rack_konami'

use Rack::Konami, html: "<img src='/images/rails.png'>", delay: 1500

app = lambda do |env|
  [200, { 'Content-Type' => 'text/html' }, '<html><body><p>Awesome Body</p></body></html>']
end

run app
```

## Rails and Sinatra

### Rails 2.3.x

Add to `config/environment.rb`:

```ruby
config.gem 'rack_konami'
config.middleware.use Rack::Konami, html: "<img src='/images/rails.png'>", delay: 1500
```

### Rails 3.x / Sinatra

Add to your `Gemfile`:

```ruby
gem 'rack_konami'
```

Then in `config.ru`:

```ruby
use Rack::Konami, html: "<img src='/images/rails.png'>", delay: 1500
```

### Rails 6.0 – 7.1

Add the gem to your `Gemfile` and install:

```ruby
gem 'rack_konami'
```

Then configure middleware in `config/application.rb` (or an initializer):

```ruby
config.middleware.use Rack::Konami, html: "<img src='/images/rails.png'>", delay: 1500
```

Open your browser and type `\u2191 \u2191 \u2193 \u2193 \u2190 \u2192 \u2190 \u2192 B A \u21B5`.

## Running Tests

```bash
bundle install
bundle exec rake test
```

## Contributing

1. Fork the project.
2. Make your feature addition or bug fix.
3. Add tests so future changes don't break your code.
4. Commit without modifying the Rakefile, version, or history.
5. Send a pull request (topic branches are appreciated).

## License

Copyright (c) 2010-2025 Mark Turner. See LICENSE for details.
