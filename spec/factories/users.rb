# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  
  salt =  'abdasdastr4325234324sdfds'

  factory :user do
    sequence(:username) { |n| "user#{n}" }
    email 'Joe.Blow@pocketbookvote.com' 
    salt salt
    password 'secret'
    crypted_password Sorcery::CryptoProviders::BCrypt.encrypt("secret", salt)
    user_first_name 'Joe'
    user_last_name 'Blow'

    factory :editor do
      after(:create) do |user, evaluator|
        user.add_role :editor, Task
      end
    end
  end
end
