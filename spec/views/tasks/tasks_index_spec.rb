require 'spec_helper'

describe 'tasks/index.html.haml' do

  def expect_selector(selector, options = nil)
    expect(rendered).to have_selector(selector, options)
  end

  before(:each) do
    @owner = build_stubbed(:user)
    @first_task = build_stubbed(:task, description: 'First task')
    @second_task = build_stubbed(:task, description: 'Second task')
    @first_role = build_stubbed_task_with_owner(@owner, @first_task)
    @second_role = build_stubbed_task_with_owner(@owner, @second_task)
    allow(view).to receive(:current_user) { @owner }
    allow(view).to receive(:policy) { double(:policy, update?: true, destroy?: false) }
    tasks = Task.all
    allow(tasks).to receive(:current_page) { 1 }
    allow(tasks).to receive(:total_pages) { 1 }
    assign :tasks, tasks
  end

  describe "the page shell" do
    before(:each) do
      render
    end

    it "has the page heading 'All Tasks'" do
      expect_selector("h1", text: 'All Tasks')
    end

    it 'has a link to create a new record' do
      expect_selector("a[href='/tasks/new']", text: 'New Task')
    end
  end
  
  describe "the export link" do
    before(:each) do
      render
    end

    context "when the results are not filtered" do
      it "has no filter parameters appended" do
        expect_selector("a[href='/tasks/export.csv']")
      end
    end

    context "when the results are filtered (no test, see comments)" do
      it "has filter parameters appended" do
        # can't figure out how to pass params at render time
        # expect_selector("a[href*='/tasks/export.csv?filter']")
      end
    end
  end    

  describe 'the task list table' do
    before(:each) do
        @owner = build_stubbed(:user)
        allow(view).to receive(:current_user) { @owner }
        allow(view).to receive(:policy) { double(:policy, update?: true, destroy?: false) }
        @first_task = build_stubbed(:task, description: 'First task')
        @second_task = build_stubbed(:task, description: 'Second task')
        @first_role = build_stubbed_task_with_owner(@owner, @first_task)
        @second_role = build_stubbed_task_with_owner(@owner, @second_task)
        allow(User).to receive(:with_role) { @first_role.users }
        tasks = [@first_task, @second_task]
        allow(tasks).to receive(:current_page) { 1 }
        allow(tasks).to receive(:total_pages) { 1 }
        allow(tasks).to receive(:limit_value) { 25 }
        assign :tasks, tasks
      end

    it 'displays all tasks' do
      render
      expect_selector("table tr td", text: 'First task')
      expect_selector("table tr td", text: 'Second task')
    end

    it 'is paginated' do
      tasks = Kaminari.paginate_array([@first_task, @second_task]).page(1).per(1)
      allow(tasks).to receive(:current_page) { 1 }
      allow(tasks).to receive(:total_pages) { 2 }
      allow(tasks).to receive(:limit_value) { 1 }
      assign :tasks, tasks
      render
      expect_selector("nav.pagination")
      expect_selector("span.current", text: "1")
    end

    describe 'each row in the task list table' do

      it 'has a link to show the full record for each task' do
        render
        expect_selector("table tr td", text: 'First task')
        expect_selector("table tr td", text: 'ISO')
        expect_selector("table tr td", text: 'Power Center 1')
        expect_selector("table tr td", text: 'Blow, Joe')
      end

      context 'if user has permission to edit the task'  do
        it 'has a link to edit the record' do
          render
          expect_selector("table tr td a[href='/tasks/#{@first_task.id}/edit']", text: 'Edit')
        end
      end

      context 'if user does not have permission to edit the record' do
        it 'has a link to view the record' do
          allow(view).to receive(:policy) { double(:policy, update?: false) }
          render
          expect_selector("table tr td a[href='/tasks/#{@first_task.id}']", text: 'View')
        end
      end

      context 'if user has permission to destroy the record' do
        it 'has a link to delete the record' do
          editor = create(:editor)
          role = build_stubbed_task_editor(editor)
          view.stub(:current_user).and_return(editor)
          view.stub(:policy).and_return double(:policy, update?: true, destroy?: true)
          render
          expect_selector("table tr td a[href='/tasks/#{@first_task.id}']", text: 'Delete')
        end
      end
    end
  end
  
  describe "the filter form" do
    before(:each) do
      render
    end

    it "has a field to specify the due date to display" do
      expect_selector("form input[name='filter[due_date]']")
    end

    it "has a field to specify the completed date to display" do
      expect_selector("form input[name='filter[completed_date]']")
    end

    it 'has a check box to toggle filtering by owner' do
      expect_selector("form input[name='filter[owner]'][type='checkbox']");
    end

    it "has a button to filter the task list table" do
      expect_selector("form input[type='submit'][value='Filter Results']")
    end
  end
end
