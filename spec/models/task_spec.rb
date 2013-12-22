require 'spec_helper'

describe Task do
  it "should be invalid without an owner" do
    expect(Task.new).to_not be_valid
  end
end
