require 'spec_helper'

describe Task do

  before(:each) do
    @user = create(:user)
    @valid_task = create(:task_with_owner, user: @user)
  end

  describe 'with_role' do
    before(:each) do
      @taskless_user = create(:user, username: 'bummed')
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
      @urgent_task = create(:task_with_owner, due_date: '2014-01-01', user: @user) 
      @trivial_task = create(:task_with_owner, due_date: '2200-01-01', user: @user) 
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

  describe "#owner" do
    
    it "returns the user with the owner role" do
      expect(@valid_task.owner).to eq(@user)
    end
  end

  describe "#owner=" do

    it "assigns the owner role to a given user" do
      user = create(:user, username: 'jane')
      task = create(:task_with_owner, user: user)
      expect(task.owner).to eq(user)
    end

    it "removes the owner role of the previous owner" do
      new_owner = create(:user, username: 'New Owner')
      @valid_task.owner = new_owner
      expect(@user.has_role?(:owner, @valid_task)).to be_false
    end
  end

  describe "#subscribers" do
    it "returns a relation with the subscribers to a task" do
      @subscriber_1 = create(:user, username: "sub_1")
      @subscriber_2 = create(:user, username: "sub_2")
      @subscriber_1.add_role :subscriber, @valid_task
      @subscriber_2.add_role :subscriber, @valid_task
      expect(@valid_task.subscribers).to match_array([@subscriber_1, @subscriber_2]) 
    end
  end

  describe "#subscribers=" do
    context "given an array of User id's" do
      it "sets the subscribers for task" do
        @subscriber_1 = create(:user, username: "sub_1")
        @subscriber_2 = create(:user, username: "sub_2")
        @subscriber_1.add_role :subscriber, @valid_task
        @subscriber_2.add_role :subscriber, @valid_task
        @valid_task.subscribers = [@subscriber_1.id, @subscriber_2.id]
        expect(@valid_task.subscribers).to match_array([@subscriber_1, @subscriber_2]) 
      end
    end
  end

  context 'is not valid when' do

    [:agency, :facility, :due_date].each do |attribute|
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
