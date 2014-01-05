class Task < ActiveRecord::Base
 
  resourcify
  
  validates :owner, :agency, :facility, :due_date, presence: true
 
  validates_date :completed_date, allow_nil: true, :on_or_before => lambda { Date.current }

  def self.filter(params, user = nil)
    result = self.all
    params.each do |field, criteria|
      if field.match(/due_date|completed_date/) && criteria.present?
        result = result.where("DATE(#{field}) = ?", criteria)
      end
    end

    if params['owner'] && user
      result = result.with_role(:owner, user)
    end

    result
  end
  
  def self.to_csv(params)
    tasks = params.nil? ? self.all : self.filter(params)
    CSV.generate do |csv|
      csv << column_names
      tasks.each do |task|
        csv << task.attributes.values
      end
    end
  end
end
