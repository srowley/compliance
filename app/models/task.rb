class Task < ActiveRecord::Base
 validates :owner, :agency, :facility, :due_date, presence: true
end
