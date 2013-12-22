# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :task do
    owner "MyString"
    agency "MyString"
    facility "MyString"
    description "MyText"
    due_date "2013-12-22 03:57:37"
    completed_date "2013-12-22 03:57:37"
  end
end
