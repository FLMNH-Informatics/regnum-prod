class SubmissionReferencePhylogeny < ApplicationRecord
  belongs_to :citation,
             dependent: :destroy
  belongs_to :submission
end