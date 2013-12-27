require_relative '../../test_helper'

describe BinDiesel do
  it "must be defined" do
    BinDiesel::VERSION.wont_be_nil
  end
end
