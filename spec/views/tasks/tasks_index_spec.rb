require 'spec_helper'

describe 'tasks/index.html.haml' do

  def expect_selector(selector, options = nil)
    expect(rendered).to have_selector(selector, options)
  end

  before(:each) do
    @first_task = create(:task, description: 'First task')
    @second_task = create(:task, description: 'Second task')
    tasks = Task.all
    assign :tasks, tasks
    render
  end

  it "has the page heading 'All Tasks'" do
    expect_selector("h1", text: 'All Tasks')
  end

  describe 'the task list table' do
    it 'displays all tasks' do
      expect_selector("table tr td", text: 'First task')
      expect_selector("table tr td", text: 'Second task')
    end
  end

  it 'has a link to create a new record' do
    expect_selector("a[href='/tasks/new']", text: 'New Task')
  end

  describe 'each row in the task list table' do

    it 'has a link to show the full record for each task' do
      expect_selector("table tr td a[href='/tasks/#{@first_task.id}']", text: 'First task')
      expect_selector("table tr td", text: 'ISO')
      expect_selector("table tr td", text: 'Power Center 1')
      expect_selector("table tr td", text: 'Steve')
    end

    it 'has a link to edit the record for that task' do
      expect_selector("table tr td a[href='/tasks/#{@first_task.id}/edit']", text: 'Edit')
    end

    it 'has a link to delete the record for that task' do
      expect_selector("table tr td a[href='/tasks/#{@first_task.id}']", text: 'Delete')
    end
  end
  
  describe "the filter form" do
     
    it "has a field to specify the due date to display" do
      expect_selector("form input[name='filter[due_date]']")
    end

    it "has a field to specify the completed date to display" do
      expect_selector("form input[name='filter[completed_date]']")
    end

    it "has a button to filter the task list table" do
      expect_selector("form input[type='submit'][value='Filter Results']")
    end
  end
  
  it "has a link for exporting results to .csv" do
    expect_selector("a[href='/tasks/export.csv']")
  end
end
