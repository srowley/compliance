class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :owner
      t.string :agency
      t.string :facility
      t.text :description
      t.datetime :due_date
      t.datetime :completed_date

      t.timestamps
    end
  end
end
