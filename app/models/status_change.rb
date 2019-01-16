class StatusChange < ActiveRecord::Base
  self.table_name = 'status_change'

  belongs_to :status
  belongs_to :submission

  before_create lambda{ self.changed_at = Time.now }

  
end