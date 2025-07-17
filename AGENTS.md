# AGENTS instructions for rack_konami

## Running tests
Run `bundle install` to ensure dependencies are installed. Then execute `bundle exec rake test`.

## Code style
* Ruby files use two space indentation.
* Keep lines under 100 characters when possible.
* Avoid trailing whitespace.

## Commit guidelines
* Do not change `Rakefile`, `VERSION`, or `rack_konami.gemspec` unless specifically
  updating the gem version in a dedicated commit.
* Ensure tests pass before opening a pull request.
