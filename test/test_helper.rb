require 'minitest/autorun'
require File.expand_path('../../lib/bin_diesel.rb', __FILE__)
require 'test_diesel'

require 'stringio'
def swallow_std_out
  out = StringIO.new
  $stdout = out
  yield
ensure
  $stdout = STDOUT
end

def capture_std_out
  out = StringIO.new
  $stdout = out
  yield
ensure
  $stdout = STDOUT
  out
end

def swallow_exit
  begin
    yield
  rescue SystemExit
  end
end
