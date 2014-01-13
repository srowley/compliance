class TaskPolicy < ApplicationPolicy

  def show?
    user.has_role? :owner, record 
  end
  
  def update?
    user.has_role? :owner, record
  end

  def destroy?
    user.has_role? :editor
  end
end
