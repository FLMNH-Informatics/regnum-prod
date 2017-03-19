class SubmissionCitationAttachment < ActiveRecord::Base
  attr_accessible :file
  has_attached_file :file #,:path => ":rails_root/public/system/submission_attachment/:id/:filename"
  belongs_to :submission
end