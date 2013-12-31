require_relative '../../lib/bin_diesel'
require_relative '../test_helper'

describe BinDiesel do
  describe "help flag" do
    it 'is equivalent to call -h and --help' do
      vincent = Class.new(TestDiesel)

      help_output = capture_std_out do
        swallow_exit { vincent.new(['--help']).run }
      end

      h_output = capture_std_out do
        swallow_exit { vincent.new(['-h']).run }
      end

      help_output.must_equal(h_output)
    end

    it 'swallows other options if help is called' do
      vincent = Class.new(TestDiesel) do
        opts_banner "This is my banner"

        opts_on '-e', '--error', 'Raise an error' do
          options.error = "Raised error"
        end

        run do
          puts options.error
        end
      end

      swallow_exit do
        lambda { vincent.new(['--error', '--help']).run }.must_output "This is my banner"
      end
    end

    it 'raises a system exit' do
      vincent = Class.new(TestDiesel)
      swallow_std_out do
        lambda{ vincent.new(["--help"]).run }.must_raise(SystemExit)
      end
    end

    it 'is not required' do
      vincent = Class.new(TestDiesel) do
        opts_banner "And here is my banner"
      end

      swallow_exit do
        lambda{ vincent.new.run }.must_output("-h, --help")
      end
    end

    describe "opts_banner" do
      it 'prints specified text on the first line when using a help flag' do
        vincent = Class.new(TestDiesel) do
          opts_banner "And here is my banner"
        end

        swallow_exit do
          lambda{TestDiesel.new(["--help"]).run}.must_output("And here is my banner")
        end
      end
    end
  end

  describe "opts_description" do
    it 'prints in help text' do
      vincent = Class.new(TestDiesel) do
        opts_description "My description"
      end

      swallow_exit do
        lambda { vincent.new(['--help']).run }.must_output("My description")
      end
    end

    it 'prints after banner in help text' do
      vincent = Class.new(TestDiesel) do
        opts_banner "The banner"
        opts_description "The description"
      end

      swallow_exit do
        lambda { vincent.new(['--help']).run }.must_output("The banner\n\nThe description")
      end
    end

    it 'is not required' do
      vincent = Class.new(TestDiesel) do
        opts_banner "My banner"
      end

      swallow_exit do
        lambda { vincent.new(['--help']).run }.must_output("My banner")
      end
    end

    it 'prints in order specified, on separate lines' do
      vincent = Class.new(TestDiesel) do
        opts_banner "My Banner"

        opts_description "description 1"
        opts_description "description 2"
      end

      swallow_exit do
        lambda { vincent.new(['--help']).run }.must_output("description 1\ndescription 2")
      end
    end
  end

  describe "opts_required" do
    it 'raises an error if option not given during execution' do
      vincent = Class.new(TestDiesel) do
        opts_on '-r', '--required [OPTION]', 'A required option' do |value|
          options.required = value
        end

        opts_required :required
      end

      swallow_exit do
        lambda { vincent.new([]).run }.must_output("!! missing argument: --required")
      end
    end

    it 'allows for more than one required option at a time'
    it 'allows for more than one required option, specified in different calls'
  end

  describe "opts_accessor" do
    it 'sets an attribute_reader for the given option'
    it 'allows for more than one option accessor at one time'
    it 'allows for more than one option accessor, specified in different calls'
  end

  describe "opts_on" do
    it 'outputs help for the option with the --help flag' do
      vincent = Class.new(TestDiesel) do
        opts_on '-f', '--flag', 'A boolean flag' do |value|
          options.flag = value
        end
      end

      swallow_exit do
        lambda { vincent.new(['--help']).run }.must_output("A boolean flag")
      end
    end

    it 'allows boolean options' do
      vincent = Class.new(TestDiesel) do
        opts_on '-b', '--boolean-flag', 'A boolean flag' do |value|
          options.flag = value
        end

        run do
          puts "flag: #{flag}"
        end
      end

      vbomb = vincent.new(['--boolean-flag'])
      vbomb.instance_variable_get(:@options).flag.must_equal(true)
    end

    it 'allows options with user supplied values' do
      vincent = Class.new(TestDiesel) do
        opts_on '-u', '--user-specified [OPTION]', 'A user specified option' do |value|
          options.user_specified = value
        end

        run do
          puts "user_specified: #{options.user_specified}"
        end
      end

      vbomb = vincent.new(['--user-specified', 'option'])
      vbomb.instance_variable_get(:@options).user_specified.must_equal('option')
    end

    it 'accepts a short flag' do
      vincent = Class.new(TestDiesel) do
        opts_on '-s', '--short [OPTION]', 'A short option' do |value|
          options.short = value
        end
      end

      vbomb = vincent.new(['-s', 'short'])
      vbomb.instance_variable_get(:@options).short.must_equal('short')
    end

    it 'accepts a long flag' do
      vincent = Class.new(TestDiesel) do
        opts_on '-l', '--long [OPTION]', 'A long flag' do |value|
          options.long = value
        end
      end

      vbomb = vincent.new(['--long', 'long'])
      vbomb.instance_variable_get(:@options).long.must_equal('long')
    end
  end

  describe "dry_run flag" do

  end

  describe "verbose flag" do

  end

  describe "post_initialize" do

  end

  describe "run" do

  end

  describe "message" do

  end

  describe "info_message" do

  end

  describe "error_message" do

  end

  describe "dry_run?" do

  end
end
