class State < ActiveRecord::Base
  has_many :phenotypes

  select_scope :label, {
    select: [ :name ]
  }
  def label
    name
  end
end