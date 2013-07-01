#! /usr/bin/env ruby

# This require allows you to load the Rails environment for use in your scripts.
 require File.expand_path(File.join(File.dirname(__FILE__),'../config/environment.rb'))

 class Test
# We are using ActiveSupport Concern.  You'll need to do this. If you don't
#   include the Rails environment as part of loading, you'll have to load
#   lib/bin_diesel.rb first.
   include BinDiesel

#  Message says it all
   def post_initialize
     message "This runs after you initialize the your instance. Could be handy."
     message "You don't need to provide me."
   end

# opts_banner is the standard header for how to execute your script.
   opts_banner "Usage: ./my_parse_example.rb [options]"

# opts_descriptions is the description of what this script does.
   opts_description "By default, this will be an awesome description."
   opts_description "You can have as many descriptions as you like,\nor add line breaks manually."

# opts_on is how you specify additional options for your script
#   You have access to 'options', which is a struct for holding your options.
#   options.dry_run and options.verbose are provided by default, set to false.
#   It takes the option flags, description strings, and a block. Only the first
#     option flag is required.
   opts_on "-p", "--pass-param PARAM", "Pass a param" do |param|
     options.param = param
   end
   opts_on "-r", "--run-fast", "Something" do
     options.fast = true
   end
   opts_on "-x", "marks the spot"

# run is is the big deal. It is what will get run when you execute
# your script. It evaluated in an instance context.
   run do
     message "I only show up if we are verbose and executing."
     puts options
     puts "INSERT CODE WITH SIDE EFFECTS HERE. :)"
   end
 end
# Run this script ala the command line...
# exit Test.new(ARGV).run
# > ./bin/test -v
