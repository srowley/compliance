require 'spec_helper'

feature 'Manage task records' do

  def fill_in_form(modifier)
    fill_in 'task_facility', with: "#{modifier} Facility"                      
    fill_in 'task_agency', with: "#{modifier} Agency"      
    fill_in 'task_owner', with: 'Stefan'                                     
    fill_in 'task_description', with: 'New Task Description'                 
    select '2015', from: 'task_due_date_1i'                                  
    select 'January', from: 'task_due_date_2i'                               
    select '1', from: 'task_due_date_3i'                                     
    click_button 'Submit'
  end
   
  before(:each) do
    @user = create(:user)
    login_user_post(@user.username, 'secret')
  end
  
  after(:each) do
    logout_user_get
  end
  
  background do
    @first_task = create(:task, description: "First task", \
                                due_date: "2013-01-01", \
                                completed_date: nil)
    @second_task = create(:task, description: "Second task", \
                                 due_date: "2014-01-01", \
                                 completed_date: "2012-01-01")
  end

  scenario 'export all to .csv file' do
    visit tasks_path
    find("a[href='/tasks/export.csv']").click
    expect(page).to have_content 'First task,'
    expect(page).to have_content 'Second task,'
  end
  
  scenario 'export filtered to .csv file' do
    visit tasks_path
    fill_in 'filter_due_date', with: '2013-01-01'
    click_button 'Filter Results'
#    puts page.html
    find("a[href*='/tasks/export.csv']").click
    expect(page).to have_content 'First task,'
    expect(page).to_not have_content 'Second task,'
  end
  
  scenario 'filter due date' do
    visit tasks_path
    fill_in 'filter_due_date', with: '2013-01-01'
    click_button 'Filter Results'
    expect(page).to have_content 'First task'
    expect(page).to_not have_content 'Second task'
  end
  
  scenario 'filter completed date' do
    visit tasks_path
    fill_in 'filter_completed_date', with: '2012-01-01'
    click_button 'Filter Results'
    expect(page).to have_content 'Second task'
    expect(page).to_not have_content 'First task'
  end
  
  scenario 'filter both dates' do
    visit tasks_path
    fill_in 'filter_due_date', with: '2013-01-01'
    fill_in 'filter_completed_date', with: '2012-01-01'
    click_button 'Filter Results'
    expect(page).to_not have_content 'First task'
    expect(page).to_not have_content 'Second task'
  end
  
  scenario 'view all records' do
    visit tasks_path
    expect(page).to have_content 'First task'
    expect(page).to have_content 'Second task'
  end
  
  scenario 'add a new record' do
    visit new_task_path
    expect{ fill_in_form("New") }.to change(Task, :count).by(1)
    expect(page).to have_content 'Record saved successfully.'
    expect(page).to have_content 'New Facility' 
  end

  scenario 'edit a record' do
    visit edit_task_path(@first_task)
    expect{ fill_in_form("Updated") }.to change(Task, :count).by(0)
    expect(page).to have_content 'Record updated successfully.'    
    expect(page).to have_content 'Updated Facility'
  end

  scenario 'delete a record' do
    visit tasks_path
    expect{ find("a[href='/tasks/1'][data-method='delete']").click
      }.to change(Task, :count).by(-1)
    expect(page).to_not have_content 'First task'
  end

end
