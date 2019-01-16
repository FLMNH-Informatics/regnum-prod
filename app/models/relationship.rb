class Relationship < ActiveRecord::Base
  self.table_name = :ontology_relationships

  belongs_to :to_concept, :class_name => "Concept"#, :include => :term#, :foreign_key => "to"
  has_one :to_concept_term, :through => :to_concept, :source => :term

  belongs_to :from_concept, :class_name => "Concept", :inverse_of => :relationships#, :foreign_key => "to"

  belongs_to :relationship_term, :inverse_of => :relationships#, :class_name => "RelationshipTerm", :foreign_key => "to"

  scope :with_terms, -> {
    joins(:relationship_term, "INNER JOIN ontology_terms ON ontology_relationships.to_concept_id = ontology_terms.concept_id").
      select("ontology_relationships.to_concept_id, ontology_terms.term as con_term, ontology_relationship_terms.term as rel_term, ontology_relationship_terms.super_sub").
      where("ontology_terms.preferred").
      order("rel_term, con_term")}

end
