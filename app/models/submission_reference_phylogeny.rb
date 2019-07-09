class SubmissionReferencePhylogeny < ApplicationRecord
  belongs_to :citation
  belongs_to :submission
end