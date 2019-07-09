class SubmissionDescriptionCitation < ApplicationRecord
  belongs_to :submission
  belongs_to :citation
end