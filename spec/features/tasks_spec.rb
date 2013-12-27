require 'spec_helper'

feature 'Manage task records' do

  background do
    first_task = create(:task, description: "First task")
    second_task = create(:task, description: "Second task")
  end

  scenario 'view all records' do
    visit tasks_path
    expect(page).to have_content 'First task'
    expect(page).to have_content 'Second task'
  end
  
  scenario 'add a new record' do
    visit new_task_path
    puts page.body
    expect{
      fill_in 'task_facility', with: 'New Facility'
      fill_in 'task_agency', with: 'New Agency'
      fill_in 'task_owner', with: 'Stefan'
      fill_in 'task_description', with: 'New Task Description'
      select '2015', from: 'task_due_date_1i'
      select 'January', from: 'task_due_date_2i'
      select '1', from: 'task_due_date_3i'
      click_button 'Add Task'
      }.to change(Task, :count).by(1)
    expect(page).to have_content 'Record saved successfully.'
    expect(page).to have_content 'New Facility' 
  end

  scenario 'edit a record'

  scenario 'delete a record'

end
