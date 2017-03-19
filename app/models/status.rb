class Status  < ActiveRecord::Base

  self.table_name = 'status'
  has_one :submission
  has_many :status_changes

  def eq?(stat)
    self.status == stat
  end

  def approved?
    self.status == 'approved'
  end

  def rejected?
    self.status == 'rejected'
  end

  def returned?
    self.status == 'returned'
  end

  def submitted?
    self.status == 'submitted'
  end

  def unsubmitted?
    self.status == 'unsubmitted'
  end
end