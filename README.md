# Tansaku

[![Build Status](https://travis-ci.org/ninoseki/tansaku.svg?branch=master)](https://travis-ci.org/ninoseki/tansaku)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/b8c176423480493182a6d52e56f6fd35)](https://www.codacy.com/app/ninoseki/tansaku)
[![Coverage Status](https://coveralls.io/repos/github/ninoseki/tansaku/badge.svg?branch=master)](https://coveralls.io/github/ninoseki/tansaku?branch=master)

Tansaku is a yet another dirbuster tool.

## Features and ToDo(s)

- [x] Custom path list to crawl
- [x] Custom User-Agent
- [x] Threading
- [x] Crawl by type (admin, backup, database, etc, log and all)

## Installation

```bash
gem install tansaku
```

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
  [--type=TYPE]                        # Type of a list to crawl (admin, backup, database, etc, log or all)
                                       # Default: all
  [--additional-list=ADDITIONAL_LIST]  # Path to the file which includes additonal paths to crawl
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

## Defined paths to crawl

See [/lib/tansaku/lists/](https://github.com/ninoseki/tansaku/blob/master/lib/tansaku/lists/).

## Alternatives

- [davidtavarez/weblocator](https://github.com/davidtavarez/weblocator)
- [maurosoria/dirsearch](https://github.com/maurosoria/dirsearch)

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
