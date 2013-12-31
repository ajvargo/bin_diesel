# Bin Diesel

## Build Status

![Build Status](https://api.travis-ci.org/dataxu/bin_diesel.png)

[Brought to you by the fine folks at Travis-CI](https://travis-ci.org/dataxu/bin_diesel)

## Introduction
Bin Diesel is a utility that will allow you to create re-usable, executable scripts easier.

Bin Diesel abstracts option parsing to simplify your 'bin' scripting.  It provides a number of wrapper methods for OptionParser, so I'd suggest having a look at that documentation to understand more of what this provides. [OptionParser Complete Example](http://ruby-doc.org/stdlib-1.9.3/libdoc/optparse/rdoc/OptionParser.html#label-Complete+example)

## What's provided? AKA, the API

It is important to note that methods are executed in the order defined.  This means you should set all options and text helpers *before* defining `run`.

### Default options

Using Bin Diesel, you get the following options for free:

* `-d`, `--dry-run`, Run script without any real changes.  Sets `@dry_run` and `options.dry_run` to `true`. Sets --verbose by default.`

The intent of `--dry-run` is to provide you with a way to run through the script and note output to verify that the script runs as intended.
We generally use this flag on `ActiveRecord` calls.  For example:

```ruby
  # ...
  run do
    users = User.where(organization: Organization.where(name: 'DataXu'))
    message "Updating #{users.count} DataXu users to be admins"
    users.update_all(admin: true) unless options.dry_run
  end
  # ...
```

The first time through, users can run the script with `--dry-run` and note the number of users that would be modified.  A second run of the script without the `--dry-run` option
will make the modifications.

* `-v, --[no-]verbose, Run verbosely`

* `-h, --help, Show description and options, and exit`

### Attributes for your ready use

* `verbose` - false by default

  The built in message helpers won't print if verbose if false, saving you the hassle.

```ruby
puts 'Something' if verbose
message "Event" # I only print if verbose is true!
```

* `options`

This is a struct that allows you to access options you configure.  Options are generally defined in `opts_on` blocks.  For example:

```ruby
class SimpleScript
  include BinDiesel

  # Accepts three arguments and a block.  The signature is:
  # opts_on [short flag], [long flag], [help text for the option]
  opts_on '-f', '--file [FILE]', 'The file to operate on' do |file_name|
    options.file_name = file_name
  end
end
```

The first two arguments define the short and long switches for the option.  The remaining N arguments are used as a description of the option (separated by newlines) displayed when the '--help' switch is provided.

See [the OptionParser documentation for `#make_switch`](http://ruby-doc.org/stdlib-1.9.3/libdoc/optparse/rdoc/OptionParser.html#method-i-make_switch) for
a description of the arguments `opts_on` accepts.  If the defined option accepts a value, the value will be passed to the block.

* `dry_run` - false by default.  This is also available through `options.dry_run`.

```ruby
do_irrecovable_change unless dry_run
```

* `args`

The args passed in to the run method.  You may have a required thing that isn't a `--option` you need to use.  This is generally an array that looks something like this (depending on the options supplied at the command line):

```ruby
['--file', 'file_name.txt', '--verbose', '--dry-run']
```

### Methods for your use

* `opts_banner(text)`

Set banner text for your script. Usually the bare usage line show an example run.

* `opts_description(text)`

Longer form text explaining what your script does.

* `opts_on *opts, &block`

Meat and potatoes. This is what you'll use to set your own options. The examples provided or [OptionParser Complete example](http://ruby-doc.org/stdlib-1.9.3/libdoc/optparse/rdoc/OptionParser.html#label-Complete+example) will give you more of an idea of what is possible.  Also see [the OptionParser documentation for `#make_switch`](http://ruby-doc.org/stdlib-1.9.3/libdoc/optparse/rdoc/OptionParser.html#method-i-make_switch).

Note the usage of `options` in the block to set values you'll use in your executing code.  Instance variables (instead of using `options`) are also acceptable.

```ruby
opts.on("-d", "--dry-run", "Run script without any real changes.", "\tSets --verbose by default.") do |dry_run|
  options.dry_run = true
  options.verbose = true
end
```

* `opts_required *args`

When parsing is done, `OptionParser::MissingArguement` will be raised for anything specified here that `options` does not respond to.

```ruby
opts_required :path
# if you never set options.path, things go BOOM.
```

* `opts_accessor *args`

Turns the provided args into accessors to help in your script writing.

```ruby
opts_accessor :path
# allows
File.open path
# instead of
File.open options.path
# or
File.open @path
```

* `dry_run?`

Some sugar for checking if `dry_run` was set.

```ruby
save_records unless dry_run?
```

* `post_initialize`

Provided so you don't have to overide Bin Diesel's initialize method.  It executes *after* all the parsing and what not, so you'll have access to options and the accessors.

```ruby
class SimpleExample
  include BinDiesel

  post_initialize do
    # Set some other useful instance variables
    @base_directory = File.dirname(__FILE__)
  end
end
```

* `run &block`

This is the big deal of your script.  You should use this as the method that'll be called to kick off your script. We do nice things for you, like catch exceptions and exit and return 1 or return 0 if all goes well.

If `run` is not implemented, the script will raise `NotImplementedError.

```ruby
run do
  campaigns = find_campaigns(options.campaign_uids)
  campaigns.each do |campaign|
    campaign.update_attribute(:name, "#{campaign.name} Update Example") unless options.dry_run
  end
end
```

* `message(text)`

puts text if `verbose` is set to `false`.  This is an extremely simple wrapper around `puts`:

```ruby
def message(text)
  puts text if verbose
end
```

* `info_message(text)`

Like `message`, but prepends with `**`

* `error_message(text)`

`puts` text, no matter the setting of `verbose`. It also prepends text with "!! "

## Installation

Add this line to your application's Gemfile:

    gem 'bin_diesel'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bin_diesel

## Usage

This is the most basic way to use Bin Diesel:

```ruby
#! /usr/bin/env ruby

class MyScript
  include BinDiesel # ahh yeah, goodies

  post_initialize do
    # Do some stuff with options before `run` is called
  end

  run do
    # I am required and will throw and exception if not defined.
    # This is what you should call, and should contain the main logic of your script.
    # If there is no exception, it'll return 0, otherwise 1 for use as an exit code
  end
end

if __FILE__ == $0  # don't run it if not called alone
  exit MyScript.new(ARGV).run  # the 0 or 1 allows you to get a proper exit code
end
```

See the Examples directory for more examples.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
