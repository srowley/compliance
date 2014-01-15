require 'spec_helper'

feature 'Manage users' do
  
  def fill_in_form
    fill_in 'user_username', with: "sclaus"                   
    fill_in 'user_email', with: "sclaus@pocketbookvote.com"      
    fill_in 'user_user_first_name', with: 'Santa'                                     
    fill_in 'user_user_last_name', with: 'Claus'
    fill_in 'user_password', with: 'secret'
  end
    
  scenario 'add a new user' do
    visit signup_path
    fill_in_form
    expect{ click_button('Sign Up') }.to change(User, :count).by(1)
    expect(page).to have_content 'Signed up.'
  end

  scenario 'add a new editor' do
    visit signup_path
    fill_in_form
    check 'editor'
    expect{ click_button('Sign Up') }.to change(User, :count).by(1)
    expect(page).to have_content 'Signed up.'
    expect(User.where(username: 'sclaus').first.has_role?(:editor, Task)).to be_true
  end
end
