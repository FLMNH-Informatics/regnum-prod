class OntologyComposition < ActiveRecord::Base
  self.table_name = :ontology_compositions
  self.primary_key = :id

  belongs_to :concept , :foreign_key => "genus_id"
end