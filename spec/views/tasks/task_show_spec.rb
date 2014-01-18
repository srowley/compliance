require 'spec_helper'

describe 'tasks/show.html.haml' do

  def expect_selector(selector, options = nil)
    expect(rendered).to have_selector(selector, options)
  end

  before(:each) do
    @owner = build_stubbed(:user)
    @task = build_stubbed(:task)
    @role = build_stubbed_task_with_owner(@owner, @task)
    allow(User).to receive(:with_role) { @role.users }

    @sub1 = build_stubbed(:user, user_first_name: "First", user_last_name: "Sub")
    @sub2 = build_stubbed(:user, user_first_name: "Second", user_last_name: "Sub")
    allow(@task).to receive(:subscribers) { [@sub1, @sub2] }

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
