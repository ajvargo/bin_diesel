require 'optparse'
require 'ostruct'

require "bin_diesel/version"

module BinDiesel
  OPTS = {:banner => nil, :description => [], :user_options => [], :required_options => [], :accessible_options => []}
  attr_reader :verbose, :options, :args, :dry_run

  module ClassMethods
    def run &block
      define_method :run do
        begin
          puts "DRY RUN" if options.dry_run
          instance_eval &block
          ending = happy_ending
        rescue Exception => e
          error_message "FAILED: #{e.message}"
          puts e.backtrace
          ending = unhappy_ending
        ensure
          ending
        end
      end
    end

    def opts_banner text
      OPTS[:banner] = text
    end

    def opts_description text
      OPTS[:description] << text
    end

    def opts_on *opts, &block
      OPTS[:user_options] << {:options => opts, :block => block }
    end

    def opts_required *args
      OPTS[:required_options] += args
    end

    def opts_accessor *args
      OPTS[:accessible_options] += args
    end
  end

  module InstanceMethods
    def initialize args
      @args = args
      @options = OpenStruct.new(:dry_run => false, :verbose => false)

      begin
        parse_options
      rescue OptionParser::MissingArgument => e
        error_message e.message
        exit unhappy_ending
      end

      @verbose = @options.verbose
      @dry_run = @options.dry_run

      setup_option_accessors

      begin
        post_initialize
      rescue Exception => e
        error_message e.message
        exit unhappy_ending
      end
    end

    def dry_run?
      @options.dry_run
    end

    def run
      raise NotImplementedError, "#{self.class} does not implement method run. You may do this explictly, or via the class level DSL (recommended):\nrun do\n ...\nend"
    end

    def post_initialize
      # TODO: EXPLAIN ME
    end

    def message text
      puts text if verbose
    end

    def info_message text
      message "** #{text}"
    end

    def error_message text
      # Always print out error messages, regardless of verbose mode
      puts "!! #{text}"
    end

    private

    def happy_ending
      0
    end

    def unhappy_ending
      1
    end

    def setup_option_accessors
      OPTS[:accessible_options].each do |opt|
        define_singleton_method opt do
          @options.send(opt)
        end

        define_singleton_method "#{opt}=" do |val|
          @options.send("#{opt}=", val)
        end
      end
    end

    def parse_options
      opts = OptionParser.new do |opts|
        opts.banner = OPTS[:banner]
        opts.separator ""

        OPTS[:description].each{|description| opts.separator description }
        opts.separator ""

        opts.separator "Specific options:"
        opts.on("-d", "--dry-run", "Run script without any real changes.", "\tSets --verbose by default.") do |dry_run|
          options.dry_run = true
          options.verbose = true
        end

        opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
          options.verbose = v
        end
        opts.separator ""

        # USER SPECIFIED
        OPTS[:user_options].each do |option|
          if option[:block]
            opts.on *(option[:options] << Proc.new{|*args| self.instance_exec(*args, &option[:block])})
          else
            opts.on *option[:options] #, (instance_eval &option[:block] if option[:block])
          end
        end
        opts.separator ""

        opts.separator "Common options:"
        opts.on_tail("-h", "--help", "Show this message") do
          puts opts
          exit happy_ending
        end
      end

      opts = opts.parse! args

      OPTS[:required_options].each do |required_option|
        raise OptionParser::MissingArgument.new("#{optionize(required_option.to_s)} - Run with --help for help.") if @options.send(required_option).nil?
      end

      opts
    end

    def optionize string
      "--#{string.gsub('_', '-')}"
    end
  end

  def self.included(base)
    base.send :include, InstanceMethods
    base.send :extend, ClassMethods
  end
end
