require 'spec_helper'

describe 'tasks/show.html.haml' do

  def expect_selector(selector, options = nil)
    expect(rendered).to have_selector(selector, options)
  end

  before(:each) do
    @user = create(:user)
    @task = create(:task_with_owner, user: @user) 
    @subscriber_1 = create(:user, username: "sub1", user_first_name: "First", user_last_name: "Sub")
    @subscriber_2 = create(:user, username: "sub2", user_first_name: "Second", user_last_name: "Sub")
    @task.subscribers = [@subscriber_1.id, @subscriber_2.id]
    assign :task, @task
    render
  end
  
  describe 'stakeholders section' do

    it "shows the owner" do
      expect(rendered).to have_selector('ul li', text: "Owner: Blow, Joe")
    end


    it "has a list of subscribers" do
      expect(rendered).to have_selector('ul li', text: "Sub, Second")
      expect(rendered).to have_selector('ul li', text: "Sub, First")
    end
  end
end
