require 'spec_helper'

describe TasksController do

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

      it 'redirects to the show template' do
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

    context 'when valid date is provided' do
      it 'flashes a success notice'

      it 'creates a new record'

      it 'renders the index template'
    end

    context 'when invalid data is provided' do
      it 'flashes an error message'

      it 'redirects to the new template'
    end
  end
  
  describe 'DELETE #destroy' do
    it 'deletes the selected record'

    it 'renders the index template'
  end
end
