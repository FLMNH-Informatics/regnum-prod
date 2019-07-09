class Citation < ApplicationRecord
  belongs_to :user, foreign_key: :created_by_id
  belongs_to :citation_type
end