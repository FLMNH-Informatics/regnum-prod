class Term < ActiveRecord::Base
  self.table_name = :ontology_terms
  belongs_to :concept, :inverse_of => :terms
  #validates_uniqueness_of :concept_id, :if => "preferred"
end
