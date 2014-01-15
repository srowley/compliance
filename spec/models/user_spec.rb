require 'spec_helper'

describe User do
  
  let(:valid_user) { build(:user) }
    
  context 'is not valid when' do

    [:username, :email, :user_first_name, :user_last_name].each do |attribute|
      it "the value of #{attribute} is nil" do
        expect(build(:user, attribute => nil)).to_not be_valid
      end
    end

    it "the username is not unique" do
      #create this object b/c one has to be persisted for validation to fail
      create(:user, username: valid_user.username)
      expect(valid_user).to_not be_valid
    end
  end
    
  context 'is valid when' do
      
    it 'all fields are completed' do
      expect(valid_user).to be_valid
    end
  end

  describe '#full_name_reversed' do

    it "returns the user's full name in 'Lastname, Firstname' form" do
      expect(valid_user.full_name_reversed).to eq("Blow, Joe")
    end
  end
end
