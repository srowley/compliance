require 'spec_helper'

describe Task do

  before(:each) do
    @valid_task = build(:task)
  end

  describe '::search' do
    it "returns tasks that match the provided due date" do
      create(:task, due_date: '2013-01-01')
      create(:task, due_date: '2014-01-01')
      expect(Task.search(due_date: '2013-01-01').count).to eq(1)
    end

    it "returns tasks that match the provided completed date" do
      create(:task, completed_date: '2013-01-01')
      create(:task, completed_date: nil)
      expect(Task.search(completed_date: '2013-01-01').count).to eq(1)
    end
  end

  context 'is not valid when' do

    [:owner, :agency, :facility, :due_date].each do |attribute|
      it "the value of " + attribute.to_s + " is nil" do
        expect(build(:task, attribute => nil)).to_not be_valid
      end
    end

    it 'the value of the completed date is not valid date' do
      expect(build(:task, completed_date: "foo")).to_not be_valid
    end

    it 'the value of the due date is not a valid date' do
      expect(build(:task, due_date: "foo")).to_not be_valid
    end

    it 'the completed date is after the current date' do
      expect(build(:task, completed_date: Time.now + 1.day)).to_not be_valid
    end

  end

  context 'is valid when' do

    it 'all fields are completed' do
      expect(@valid_task).to be_valid
    end

    it 'the completed date is blank' do
      expect(build(:task, completed_date: nil)).to be_valid
    end
  end

  it "returns a filtered list when given search criteria" do
    create(:task, due_date: '2013-01-01')
    create(:task, due_date: '2014-01-01')
    expect(Task.search(due_date: '2013-01-01').count).to eq(1)
  end
end
