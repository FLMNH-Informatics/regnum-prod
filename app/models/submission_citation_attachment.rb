class SubmissionCitationAttachment < ApplicationRecord
  #not in rails 5
  # attr_accessible :file

  # has_attached_file :file #,:path => ":rails_root/public/system/submission_attachment/:id/:filename"
  # validates_attachment_content_type
  belongs_to :submission
end