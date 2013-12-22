class Task < ActiveRecord::Base
 validates :owner, presence: true
end
