require 'spec_helper'

describe Role do
  
  it 'is capable of having a valid factory' do
    user = create(:user)
    task = create(:task_with_owner, user_id: user.id)
    expect(user.has_role? :owner, task).to be_true
  end
  
end
