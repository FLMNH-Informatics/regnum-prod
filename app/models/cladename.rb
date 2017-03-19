class Cladename < ActiveRecord::Base
  self.table_name = 'submissions'

  belongs_to :user , :class_name => "User"
  #belongs_to :submission, :class_name => "Submission"
  #scope :submissions, where("status_id <> ?", Status.where("status = 'accepted'").status_id)
  #scope :approved, where("status_id = ?", Status.where("status = 'accepted'").status_id)

  before_create :stamp_record

  private

  def stamp_record
    time = Time.now
    #can always recreate guid with timestamp
    self.approved_on = time
    self.guid = generate_guid(time)
  end

  def generate_guid(time=nil)
    UUIDTools::UUID.timestamp_create(time)
  end

end