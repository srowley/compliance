require 'spec_helper'

describe TasksController do
  
  before(:each) do
    @user = create(:user)
    login_user
  end
  
  after(:each) do
    logout_user
  end
  
  describe 'GET #export' do
    render_views
    
    before(:each) do
      create(:task, due_date: '2013-01-01')
      create(:task, due_date: '2015-01-01')
    end
    
    context "when all records are displayed" do
      it "exports all records to csv" do
        get :export, :format => 'csv'
        expect(response.body).to match /2013-01-01/
        expect(response.body).to match /2015-01-01/
      end
    end
    
    context "when filtered records are displayed" do
      it "exports only filtered records to csv" do
        get :export, { :format => 'csv', 'filter' => { due_date: '2013-01-01' } }
        expect(response.body).to match /2013-01-01/
        expect(response.body).to_not match /2015-01-01/
      end
    end
  end
      
  describe 'GET #search' do
    it "returns the records that match the given due date" do
      create(:task, due_date: '2013-01-01')
      create(:task, due_date: '2014-01-01')
      get :search, 'filter' => { due_date: '2013-01-01' }
      expect(assigns(:tasks)).to eq Task.search(due_date: '2013-01-01' )
    end

    it "returns the records that match the given completed date" do
      create(:task, completed_date: '2012-01-01')
      create(:task, completed_date: '2013-01-01')
      get :search, 'filter' => { completed_date: '2012-01-01' }
      expect(assigns(:tasks)).to eq Task.search(completed_date: '2012-01-01')
    end

    it "renders the index template" do
      get :search, 'filter' => { due_date: '2012-01-01' }
      expect(response).to render_template :index
    end
  end
  
  describe 'GET #index' do
    it 'returns a list of all Task objects' do
      get :index
      expect(assigns(:tasks)).to eq Task.all
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do

    it 'returns the requested Task object' do
      task = create(:task)
      get :show, id: task
      expect(assigns(:task)).to eq task
    end

    it 'renders the show template' do
      task = create(:task)
      get :show, id: task
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do

    it 'creates a blank Task object' do
      get :new
      expect(assigns(:task)).to be_a_new(Task)
    end
     
    it 'renders the new template' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    
    it "returns the requested task object" do
      task = create(:task)
      get :edit, id: task
      expect(assigns(:task)).to eq task
    end

  end

  describe 'PATCH #update' do

    context 'when the updated attributes are valid' do
      before(:each) do
        @task = create(:task, agency: 'old agency')
        patch :update, id: @task, task: attributes_for(:task, agency: 'new agency')
        @task.reload
      end

      it 'updates the attributes for the edited task' do
        expect(@task.agency).to eq('new agency')
      end

      it 'redirects to task#show' do
        expect(response).to redirect_to @task
      end
    end

    context 'when the updated attributes are not valid' do
      before(:each) do
        @task = create(:task, agency: 'old agency', facility: 'old facility')
        patch :update, id: @task, task: attributes_for(:task, agency: nil, facility: 'new facility')
        @task.reload
      end

      it 'does not update the record' do
        expect(@task.agency).to eq('old agency')
        expect(@task.facility).to_not eq('new facility')
      end

      it 're-renders the edit template' do
        expect(response).to render_template :edit
      end

      it 'flashes an alert message' do
        expect(flash[:alert]).to eq('Update invalid. Record not saved.')
      end
    end
  end

  describe 'POST #create' do

    context 'when valid data is provided' do
    
      it 'saves the record' do
        expect { post :create, task: attributes_for(:task) }.to change(Task, :count).by(1)
      end

      it 'flashes a success notice' do
        post :create, task: attributes_for(:task)
        expect(flash[:notice]).to eq('Record saved successfully.')
      end

      it 'redirects to task#show' do
        post :create, task: attributes_for(:task)
        expect(response).to redirect_to tasks_path
      end
    end

    context 'when invalid data is provided' do

      it 'does not save the record' do
        expect { post :create, task: attributes_for(:task, agency: nil) }.to change(Task, :count).by(0)
      end
        
      it 'flashes an error alert' do
        post :create, task: attributes_for(:task, agency: nil)
        expect(flash[:alert]).to eq('Data invalid. Record not saved.')
      end

      it 'redirects to task#new' do
        post :create, task: attributes_for(:task, agency: nil)
        expect(response).to render_template :new
      end
    end
  end
  
  describe 'DELETE #destroy' do
    before(:each) do
      @task = create(:task)
    end

    it 'deletes the selected record' do
      expect { delete :destroy, id: @task }.to change(Task, :count).by(-1)
    end

    it 'redirects to tasks#index' do
      delete :destroy, id: @task
      expect(response).to redirect_to tasks_path
    end
  end
end
