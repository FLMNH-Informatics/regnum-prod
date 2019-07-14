class SubmissionDescriptionCitation < ApplicationRecord
  belongs_to :submission
  belongs_to :citation,
             dependent: :destroy
end