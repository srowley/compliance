class User < ActiveRecord::Base
  rolify
  authenticates_with_sorcery!
  
  validates :username, :user_first_name, :user_last_name, :email, presence: true
  validates_uniqueness_of :username

  def full_name_reversed
    "#{user_last_name}, #{user_first_name}"
  end

end
