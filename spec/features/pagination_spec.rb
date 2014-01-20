require 'spec_helper'

feature 'Task list pagination' do

  scenario 'view list with more than 25 tasks' do
    user = create(:user, username: 'jane', user_first_name: 'Jane')
    tasks = create_list(:task_with_owner, 26, \
                                 description: "First task", \
                                 due_date: "2013-01-01", \
                                 completed_date: nil, \
                                 user: user)

    login_user_post(user.username, 'secret')
    visit tasks_path
    expect(page).to have_selector('tbody tr:nth-child(25)')
    expect(page).to_not have_selector('tbody tr:nth-child(26)')
    logout_user_get
  end
end
