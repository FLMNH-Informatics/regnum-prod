class StatusChange < ApplicationRecord
  self.table_name = 'status_change'

  belongs_to :status
  belongs_to :submission

  before_create lambda{ self.changed_at = Time.now }

  
end