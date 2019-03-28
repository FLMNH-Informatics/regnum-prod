class Character < ApplicationRecord
  self.primary_key = :id
  has_many :states
  select_scope :label, {
    select: [ :name ]
  }
  def label
    name
  end
end
