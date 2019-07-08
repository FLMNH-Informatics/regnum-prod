class Citation < ApplicationRecord
  belongs_to :user, foreign_key => :created_by
  belongs_to :citation_type
end