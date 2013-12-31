require 'spec_helper'

feature 'Log in and out' do
  
  scenario "Log in and then log out" do
    @user = create(:user)
    visit login_path
    fill_in 'username', with: 'jblow'
    fill_in 'password', with: 'secret'
    click_button 'Log In'
    expect(page).to have_content "Logged in."
    visit logout_path
    expect(page).to have_content "Logged out."
  end
  
end