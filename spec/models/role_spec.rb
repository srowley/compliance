require 'spec_helper'

describe 'Role', skip: true do
  describe 'stubbed assignment of editor role to Task' do
    it "has the 'editor' role name" do
      @role = build_stubbed_task_editor
      expect(@role.name).to eq("editor")
    end
  end

  describe 'stubbed assignment of owner role to a task' do
    before(:each) do
      @task = build_stubbed(:task)
      @user = build_stubbed(:user)
      @role = build_stubbed_task_with_owner(@user, @task)
      allow(User).to receive(:with_role) { @role.users }
    end

    it "has the 'owner' role name" do
      expect(@role.name).to eq("owner")
    end

    it "has a user" do
      expect(@role.users.first.user_first_name).to eq("Joe")
    end

    it "has a task" do
      expect(@role.resource.agency).to eq("ISO")
    end

    describe "stubbed ::with_role" do
      it "returns the user object that is the task owner" do
        expect(User.with_role(:owner, @role.resource).first.user_first_name).to eq("Joe")
      end
    end

    describe "stubbed ::has_role?" do
      context "when passed ':owner' and the task object'" do
        it "returns true for the assigned task and owner" do
          expect(@role.users.first.has_role?(:owner, @role.resource)).to be_true
        end
      end

      context "when passed another role for the task object" do
        it "returns false" do
          expect(@role.users.first.has_role?(:subscriber, @role.resource)).to be_false
        end
      end
    end
  end
end

