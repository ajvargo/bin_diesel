require_relative '../../lib/bin_diesel'
require_relative '../test_helper'

describe BinDiesel do
  describe "help flag" do
    it 'is equivalent to call -h and --help'
    it 'swallows other options if help is called'

    it 'raise a system exit' do
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
    it 'prints in help text'
    it 'prints after banner in help text'
    it 'is not required'
    it 'prints in order specified, on separate lines'
  end

  describe "opts_required" do
    it 'raises an error if option not given during execution'
    it 'allows for more than one required option at a time'
    it 'allows for more than one required option, specified in different calls'
  end

  describe "opts_accessor" do
    it 'sets an attribute_reader for the given option'
    it 'allows for more than one option accessor at one time'
    it 'allows for more than one option accessor, specified in different calls'
  end

  describe "opts_on" do

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
