# Bin Diesel

## Introduction
Bin Diesel is a utility that will allow you to create re-usable, executable scripts easier.

Bin Diesel abstracts option parsing to simplify your 'bin' scripting.  It provides a number of wrapper methods for OptionParser, so I'd suggest having a look at that documentation to understand more of what this provides. [OptionParser Complete example](http://ruby-doc.org/stdlib-1.9.3/libdoc/optparse/rdoc/OptionParser.html#label-Complete+example)

## What's provided? AKA, the API

It is important to note that methods are executed in the order defined.  This means you should set all options and text helpers *before* defining `run`.

### Default options

Using Bin Diesel, you get the following options for free:

* `-d, --dry-run, "Run script without any real changes. Sets --verbose by default.`

* `-v, --[no-]verbose, Run verbosely`

* `-h, --help, Show description and options`

### Attributes for your ready use

* `verbose` - false by default

  The built in message helpers won't print if verbose if false, saving you the hassle.
    
    ```ruby
    puts 'Something' if verbose
    message "Event" # I only print if verbose is true!
    ```

* `options`

  This is struct that allows you to access options you configure.

    ```ruby
    File.open options.my_file_path
    ```

* `dry_run` - false by default

    ```ruby
    do_irrecovable_change unless dry_run
    ```

* `args`

The args passed in to the run method.  You may have a required thing that isn't a `--option` you need to use.

### Methods for your use

* `opts_banner_text(text)`

Set banner text for your script. Usually the bare usage line show an example run.

* `opts_description(text)`

Longer form text explaining what your script does.

* `opts_on *opts, &block`

Meat and potatoes. This is what you'll use to set your own options. The examples provided or [OptionParser Complete example](http://ruby-doc.org/stdlib-1.9.3/libdoc/optparse/rdoc/OptionParser.html#label-Complete+example) will give you more of an idea of what is possible.

Note the usage of `options` in the block to set values you'll use in your executing code.

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
    unless dry_run? {...}
    ```

* `post_initialize`

Provided so you don't have to overide Bin Diesel's initialize method.  It executes *after* all the parsing and what not, so you'll have access via options and the accessors.

* `run &block`

This is the big deal of your script.  You should use this as the method that'll be called to kick off your script. We do nice things for you, like catch exceptions and exit and return 1 or return 0 if all goes well.

    ```ruby
    run do
      ima_private_method
      ima_nother
    end
    ```

* `message(text)`

puts text if `verbose` is set to `false`

* `info_message(text)`

Like `message`, but prepends with "**"

* `error_text(text)`

puts text, no matter the setting of `verbose`. It also prepends text with "!! "

## Installation

Add this line to your application's Gemfile:

    gem 'bin_diesel'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bin_diesel

## Usage

This is the most basic way to use Bin Diesel:

    #! /usr/bin/env ruby

    class MyScript
      include BinDiesel # ahh yeah, goodies

      def run
        # I am required and will throw and exception if not defined.
        # This is what you should call, and should contain the main logic of your script.
        # If there is no exception, it'll return 0, otherwise 1 for use as an exit code
      end
    end

    if __FILE__ == $0  # don't run it if not called alone
      exit MyScript.new(ARGV).run  # the 0 or 1 allows you to get a proper exit code
    end

See the Examples directory for more examples.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
