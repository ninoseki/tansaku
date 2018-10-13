# Tansaku

Tansaku is a yet another dirbuster tool.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tansaku'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tansaku

## Usage

### As a CLI

```sh
$ tansaku
Commands:
  tansaku crawl URL       # Crawl a given URL
  tansaku help [COMMAND]  # Describe available commands or one specific command

$ tansaku help crawl
Usage:
  tansaku crawl URL

Options:
  [--additional-list=ADDITIONAL_LIST]  # Path to the additonal crawling pats file
  [--threads=N]                        # Number of threads to use
  [--user-agent=USER_AGENT]            # User-Agent parameter to use

Crawl a given URL
```

### As a library

```ruby
crawler = Tansaku::Crawler("http://localhost")
resutls = crawler.crawl
p results
```

## Alternatives

- [davidtavarez/weblocator](https://github.com/davidtavarez/weblocator)
- [maurosoria/dirsearch](https://github.com/maurosoria/dirsearch)

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
