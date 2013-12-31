require 'spec_helper'

describe SessionsController do

  describe "GET #new" do
    it "renders the new template" do
      get :new
      expect(response).to render_template :new
    end
  end
  
  describe "POST #create" do
    context "when offered valid credentials" do
      before(:each) do
        create(:user, username: 'joe', password: 'secret')
        post :create, username: 'joe', password: 'secret', remember_me: false
      end
      
      it "logs in a user" do
        expect(controller).to be_logged_in
      end
      
      it "flashes a success message" do
        expect(flash[:notice]).to eq('Logged in.')
      end
      
      it "redirects to the root url" do
        expect(response).to redirect_to root_url
      end
    end
    
    context "when offered invalid credentials" do
      before(:each) do
        create(:user, username: 'joe', password: 'secret')
        post :create, username: 'joe', password: 'wrong'
      end
 
      it "doesn't log in the user" do
        expect(controller).to_not be_logged_in
      end

      it "flashes an error message" do
        expect(flash[:alert]).to eq("Username or password was invalid.")
      end
    
      it "redirects to sessions#new" do
        expect(response).to redirect_to new_session_path
      end
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      user = create(:user)
      login_user(user)
      delete :destroy
    end
    
    it 'logs out the user' do
      expect(controller).to_not be_logged_in
    end
    
    it 'flashes a success message' do
      expect(flash[:notice]).to eq("Logged out.")
    end
    
    it 'redirects to the root url' do
      expect(response).to redirect_to root_url
    end
  end
end