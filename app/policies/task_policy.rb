class TaskPolicy < ApplicationPolicy
  
  def update?
    user.has_role?(:owner, record) || user.has_role?(:editor, Task)
  end

  def destroy?
    user.has_role? :editor, Task
  end
end
