# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :task do
  
    agency "ISO"
    facility "Power Center 1"
    description "This task must absolutely be done"
    due_date "2013-12-22 03:57:37"
    completed_date "2013-12-22 03:57:37"
    
    factory :task_with_owner do
      ignore do
        user nil
      end
    
      after(:create) do |task, transients|
        task.owner = transients.user
      end
      
      after(:stub) do |task, transients|
        task.owner = transients.user
      end
    end
  end
end
