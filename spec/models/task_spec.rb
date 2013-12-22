require 'spec_helper'

describe Task do

  before(:each) do
    @valid_task = FactoryGirl.build(:task)
  end

  [:owner, :agency, :facility, :due_date].each do |attribute|
    it "should be invalid without an " + attribute.to_s do
      expect(FactoryGirl.build(:task, attribute => nil)).to_not be_valid
    end
  end

  it "should be valid if all fields are completed" do
    expect(@valid_task).to be_valid
  end

  it "should be valid even without a completed date" do
    expect(FactoryGirl.build(:task, completed_date: nil)).to be_valid
  end

end
