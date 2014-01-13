class TaskPolicy < ApplicationPolicy

  def update?
    user.has_role? :owner, record
  end
end
