require 'spec_helper'

describe Task do

  before(:each) do
    @valid_task = FactoryGirl.create(:task)
  end

  it "should be invalid without an owner" do
    expect(Task.new).to_not be_valid
  end

  it "should be valid if all fields are completed" do
    expect(@valid_task).to be_valid
  end

end
