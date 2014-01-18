FactoryGirl.define do
  factory :role do
    resource_type "Task"
    name "owner"
    users { [build_stubbed(:user)] }
    association :resource, factory: :task, strategy: :build_stubbed

    factory :editor_role do
      name "editor"
      resource { nil }
    end
  end
end
