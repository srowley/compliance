# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :task do
  
    owner "Steve"
    agency "ISO"
    facility "Power Center 1"
    description "This task must absolutely be done"
    due_date "2013-12-22 03:57:37"
    completed_date "2013-12-22 03:57:37"
    
    factory :task_with_owner do
      ignore do
        user_id nil
      end
    
      after(:create) do |task, user_id|
        User.find(user_id).add_role :owner, task
      end
    end
  
  end
end
