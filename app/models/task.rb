class Task < ActiveRecord::Base
 validates :owner, :agency, :facility, :due_date, presence: true
 validates_date :completed_date, allow_nil: true
end
