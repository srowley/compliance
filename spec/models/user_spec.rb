require 'spec_helper'

describe User do
  
  describe "validations" do
    before(:each) do
      @valid_user = build(:user)
    end
    
    context 'is not valid when' do

      [:username, :email, :user_first_name, :user_last_name].each do |attribute|
        it "the value of #{attribute} is nil" do
          expect(build(:user, attribute => nil)).to_not be_valid
        end
      end

      it "the username is not unique" do
        create(:user)
        expect(@valid_user).to_not be_valid
      end
    end
    
    context 'is valid when' do
      
      it 'all fields are completed' do
        expect(@valid_user).to be_valid
      end
    end
  end
end
