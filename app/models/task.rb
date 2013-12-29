class Task < ActiveRecord::Base
 
  validates :owner, :agency, :facility, :due_date, presence: true
 
  validates_date :completed_date, allow_nil: true, :on_or_before => lambda { Date.current }

  def self.search(params)	
    result = self.all
    params.each do |field, criteria|
      if field.match(/due_date|completed_date/) && criteria.present?
        result = result.where("DATE(#{field}) = ?", criteria)
      end
    end
    result
  end

end
