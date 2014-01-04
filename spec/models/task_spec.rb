require 'spec_helper'

describe Task do

  before(:each) do
    @valid_task = create(:task)
  end

  describe 'with_role' do
    before(:each) do
      @user = create(:user)
      @taskless_user = create(:user, username: 'bummed')
      @user.add_role :owner, @valid_task
    end
    
    context 'when the user has a role on the task' do
      it 'returns a list of tasks with that role bound' do
        expect(Task.with_role(:owner, @user).count).to eq(1)
      end
    end
    
    context 'when the user does not have a role on the task' do
      it 'excludes that task from list of task for that role' do
        expect(Task.with_role(:owner, @taskless_user).count).to eq(0)
      end
    end
  end
  
  describe '::to_csv' do
    before(:each) do
      @urgent_task = create(:task, due_date: '2014-01-01') 
      @trivial_task = create(:task, due_date: '2200-01-01') 
    end
    
    it 'returns csv formatted text' do
      expect(Task.to_csv(nil)).to match /2014-01-01/
      expect(Task.to_csv(nil)).to match /2200-01-01/
    end
    
    it 'applies a supplied filter' do
      expect(Task.to_csv( { due_date: '2014-01-01' } )).to match /2014-01-01/
      expect(Task.to_csv( { due_date: '2014-01-01'} )).to_not match /2200-01-01/
    end    
  end

  describe '::filter' do
    it "returns tasks that match the provided due date" do
      create(:task, due_date: '2013-01-01')
      create(:task, due_date: '2014-01-01')
      expect(Task.filter(due_date: '2013-01-01').count).to eq(1)
    end

    it "returns tasks that match the provided completed date" do
      create(:task, completed_date: '2013-01-01')
      create(:task, completed_date: nil)
      expect(Task.filter(completed_date: '2013-01-01').count).to eq(1)
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
end
