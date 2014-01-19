require 'spec_helper'

feature "Create audit trail" do
  before(:each) do
    @user = create(:user)
    @task = create(:task_with_owner, user: @user)
    login_user_post(@user.username, 'secret')
  end

  after(:each) do
    logout_user_get
  end

  scenario "Update task and review audit trail" do
    with_versioning do
      visit edit_task_path(@task)
      fill_in 'task_agency', with: "NERC"
      click_button "Submit"
      click_link "Audit Trail"
      expect(page).to have_selector("table tbody tr td", text: "ISO")
      expect(page).to have_selector("table tbody tr td", text: "NERC")
    end
  end
end
