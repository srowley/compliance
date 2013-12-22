class Task < ActiveRecord::Base
 validates :owner, presence: true
 validates :agency, presence: true
 validates :facility, presence: true
 validates :due_date, presence: true
end
