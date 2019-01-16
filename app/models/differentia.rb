class Differentia < ActiveRecord::Base
  self.table_name = "differentiae"
  self.primary_key = :id

  belongs_to :relation_term, :foreign_key => "property_id" , :class_name => "Concept"
  belongs_to :ontology_term, :foreign_key => "value_id" , :class_name => "Concept"
  belongs_to :entity_term, :foreign_key => "ontology_compositon_id" , :class_name => "Phenotype"
  belongs_to :dependent_term, :foreign_key => "related_entity_ontology_id" , :class_name => "Phenotype"
  belongs_to :quality_term, :foreign_key => "quality_ontology_id" , :class_name => "Phenotype"
  belongs_to :unit_term, :foreign_key => "unit_ontology_id" , :class_name => "Phenotype"
end