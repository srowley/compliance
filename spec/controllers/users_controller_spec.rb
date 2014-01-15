require 'spec_helper'

describe UsersController do
  
  describe "GET 'new'" do
    it 'creates a blank User object' do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
    
    it 'renders the new template' do
      get :new
      expect(response).to render_template :new
    end
  end
  
  describe 'POST #create' do

    context 'when valid data is provided' do
    
      it 'saves the record' do
        expect { post :create, user: attributes_for(:user) }.to change(User, :count).by(1)
      end

      it 'flashes a success notice' do
        post :create, user: attributes_for(:user)
        expect(flash[:notice]).to eq('Signed up.')
      end

      it 'redirects to login page' do
        post :create, user: attributes_for(:user)
        expect(response).to redirect_to login_path
      end
    end

    context 'when invalid data is provided' do

      it 'does not save the record' do
        expect { post :create, user: attributes_for(:user, username: nil) }.to change(User, :count).by(0)
      end
        
      it 'redirects to user#new' do
        post :create, user: attributes_for(:user, username: nil)
        expect(response).to render_template :new
      end
    end

    context 'when editor flag is true' do

      it 'adds the editor role' do
        params = { "user" => attributes_for(:user), "editor" => "true" }
        post :create, params
        expect(assigns(:user).has_role?(:editor, Task)).to be_true
      end
    end
    
    context 'when editor flag is not true' do

      it 'does not add the editor role' do
        params = { "user" => attributes_for(:user), "editor" => "other" }
        post :create, params
        expect(assigns(:user).has_role?(:editor, Task)).to be_false
      end
    end
  end
end
