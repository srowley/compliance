require 'spec_helper'

feature 'Authentication' do
  
  background do
    @user = create(:user)
  end
  
  scenario "Log in and then log out" do
    visit login_path
    fill_in 'username', with: @user.username
    fill_in 'password', with: 'secret'
    click_button 'Log In'
    expect(page).to have_content "Logged in."
    expect(page).to have_content "Log Out"
    visit logout_path
    expect(page).to have_content "Logged out."
    expect(page).to have_content "Log In"
  end
  
#  context "When not logged in" do
#    scenario "redirect to log in page when visiting tasks page" do
#      visit tasks_path
#      expect(page).to have_content "Username"
#      expect(page).to_not have_content "Tasks"
#      expect(page).to have_content "Log in to view"
#    end
#  end
  
  context "When logged in" do
    scenario "render tasks page when visiting tasks page" do
      login_user_post @user.username, 'secret'
      visit tasks_path
      expect(page).to have_content "Tasks"
      expect(page).to_not have_content "Username"     
    end
  end
end
