require 'spec_helper'

describe 'tasks/show.html.haml' do

  def expect_selector(selector, options = nil)
    expect(rendered).to have_selector(selector, options)
  end

  before(:each) do
    @user = create(:user)
    @task = create(:task_with_owner, user: @user) 
    assign :task, @task
    render
  end
  
  describe 'roles table' do

    it "has a list of each user with a role and their role" do
      expect(rendered).to have_selector('ul li', text: "Owner: Blow, Joe")
    end

  end

end
