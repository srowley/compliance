require 'spec_helper'

def build_stubbed_task_with_owner(user=nil, task)
  user ||= build_stubbed(:user)
  role = build_stubbed(:role, users: [user], resource: task)

  allow(user).to receive(:has_role?) do |name, resource|
    false
    true if name == :owner && resource == task
  end
  
  role
end

def build_stubbed_task_editor(user=nil)
  user ||= build_stubbed(:stubbed_editor)
  role = build_stubbed(:editor_role)
  allow(user).to receive(:has_role?) do |name, resource|
    false
    true if name == :editor && resource == Task
  end

  role
end
