# Tansaku

[![Gem Version](https://badge.fury.io/rb/tansaku.svg)](https://badge.fury.io/rb/tansaku)
[![Build Status](https://travis-ci.com/ninoseki/tansaku.svg?branch=master)](https://travis-ci.com/ninoseki/tansaku)
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
$ tansaku help
Usage:
  tansaku crawl URL

Options:
  [--additional-list=ADDITIONAL_LIST]                              # Path to the file which includes additional paths to crawl
  [--headers=key:value]                                            # HTTP headers to use
  [--method=METHOD]                                                # HTTP method to use
                                                                   # Default: HEAD
  [--body=BODY]                                                    # HTTP request body to use
  [--timeout=N]                                                    # Timeout in seconds
  [--max-concurrent-requests=N]                                    # Max number of concurrent requests to use
  [--ignore-certificate-errors], [--no-ignore-certificate-errors]  # Whether to ignore certificate errors or not
  [--type=TYPE]                                                    # Type of a list to crawl (admin, backup, database, etc, log or all)
                                                                   # Default: all

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

- [maurosoria/dirsearch](https://github.com/maurosoria/dirsearch): Web path scanner
- [evilsocket/dirsearch](https://github.com/evilsocket/dirsearch): A Go implementation of dirsearch.
- [davidtavarez/weblocator](https://github.com/davidtavarez/weblocator): Just a better dirbuster
- [stefanoj3/dirstalk](https://github.com/stefanoj3/dirstalk): Modern alternative to dirbuster/dirb

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
