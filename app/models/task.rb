class Task < ActiveRecord::Base

 validates :owner, :agency, :facility, :due_date, presence: true

 validates_date :completed_date, allow_nil: true, :on_or_before => lambda { Date.current }

 def self.search(params)
   where('DATE(due_date) = ?', params[:due_date])
 end

end
