# LibraryAssistant ![](https://travis-ci.org/maloneyl/library_assistant.svg?branch=master)

This is a little pet project that helps me manage my reading and gives me something to experiment with.

I read a lot and get almost all of my books from the library. As much as I love my local library (hi, Islington 👋🏽), its website leaves a lot to be desired. It was also getting a bit silly how often I'd look up a book on both Goodreads (to check reviews and add to my to-read shelf) and the library catalogue (to see if the book's even stocked), so I thought I should try to automate that process.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'library_assistant'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install library_assistant

## Usage

See `.env.example` for the required `.env` setup. The Goodreads credentials involved are an API key, a user ID, and the name of a shelf associated with that user ID.

All `LibraryAssistant` methods involve first getting the most recently added books (up to 20) on the Goodreads shelf specified in your `.env`:

* `LibraryAssistant.grab_a_book` returns the first book found in the Islington library catalogue. See [library-assistant-cli](https://github.com/maloneyl/library-assistant-cli) for how I use it, which was how this project started.

* `LibraryAssistant.generate_and_process_book_requests` returns processed book requests with their library search results. By default, only the ones with books found are returned. You can pass the method the following options:

  * `include_all: true`: To get back all processed book requests, including ones with bookless search results.

  * `desired_book_count: {number}`: To _attempt_ to get at least that many processed book requests with library books found, looking beyond the first 20 Goodsreads books if needed. See [library-assistant-web](https://github.com/maloneyl/library-assistant-web) for an example.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/maloneyl/library_assistant.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
