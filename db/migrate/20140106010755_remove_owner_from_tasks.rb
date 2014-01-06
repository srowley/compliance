class RemoveOwnerFromTasks < ActiveRecord::Migration

  def up
    remove_column :tasks, :owner
  end

  def down
    add_column :tasks, :owner, :string
  end
end
