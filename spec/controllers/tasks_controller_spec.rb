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

    it 'returns an updated Task object'

    it 'renders the index template'
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
