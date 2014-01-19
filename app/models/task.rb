class Task < ActiveRecord::Base
 
  resourcify
  has_paper_trail
  
  validates :agency, :facility, :due_date, presence: true
 
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
      csv << (column_names << 'owner')
      tasks.each do |task|
        csv << (task.attributes.values << task.owner.full_name_reversed)
      end
    end
  end

  def owner
    User.with_role(:owner, self).first
  end

  def owner=(user)
    self.owner.remove_role(:owner, self) if User.with_role(:owner, self).count > 0
    user.add_role(:owner, self)
  end

  def subscribers
    User.with_role(:subscriber, self)
  end

  def subscribers=(users = [])

    subscribers.each do |subscriber|
      subscriber.remove_role :subscriber, self
    end
    
    users.each do |user|
      User.find(user).add_role :subscriber, self
    end
  end
end
