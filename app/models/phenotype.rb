class Phenotype < ActiveRecord::Base
  self.table_name = :phenotypes
  self.primary_key = :id

  belongs_to :entity, :class_name => "Concept"
  belongs_to :quality_term , :foreign_key => "quality_id" , :class_name => "Concept"
  belongs_to :dependent_term , :foreign_key => "dependent_entity_id" , :class_name => "Concept"
  belongs_to :unit_term , :foreign_key => "unit_id" , :class_name => "Concept"
  #belongs_to :state
  #has_many :quality_terms, :primary_key => :quality_id
  #has_many :unit_terms, :primary_key => :unit_id
  #has_many :dependent_terms, :primary_key => :dependent_entity_id
  #has_many :entity_terms, :primary_key => :entity_id

end