require 'spec_helper'

feature 'Manage users' do
  
  def fill_in_form
    fill_in 'user_username', with: "sclaus"                   
    fill_in 'user_email', with: "sclaus@pocketbookvote.com"      
    fill_in 'user_user_first_name', with: 'Santa'                                     
    fill_in 'user_user_last_name', with: 'Claus'
    fill_in 'user_password', with: 'secret'
    click_button 'Sign Up'
  end
  
  scenario 'add a new user' do
    visit signup_path
    expect{ fill_in_form }.to change(User, :count).by(1)
    expect(page).to have_content 'Signed up.'
  end
end