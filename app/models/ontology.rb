class Ontology < ActiveRecord::Base
  has_many :concepts, :inverse_of => :ontology
  has_and_belongs_to_many :users

end