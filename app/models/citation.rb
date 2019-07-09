class Citation < ApplicationRecord
  belongs_to :user, foreign_key: :created_by_id
  belongs_to :citation_type

  serialize :authors, Array
  serialize :editors, Array
  serialize :series_editors, Array


  def self.create_from_json json
    Citation.new(
      :citation_type => CitationType.find_by_citation_type(json[:citation_type])
    )
  end
end