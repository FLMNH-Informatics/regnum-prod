class Concept < ActiveRecord::Base
  self.table_name = :ontology_concepts

  has_many :relation_compositions, :class_name => "Differentia" , :foreign_key => "value_id"
  has_many :differentiae_compositions, :class_name => "Differentia" , :foreign_key => "property_id"
# has_many :ontology_compositions, :class_name => "OntologyComposition" , :foreign_key => "genus_id"

  belongs_to :ontology, :inverse_of => :concepts

  has_many :terms, :inverse_of => :concept, :order => "term"#, :dependent => :delete_all
  has_one :term, :conditions => "preferred"

  has_many :relationships, :foreign_key => "from_concept_id", :inverse_of => :from_concept
           #:dependent => :destroy#, :include => [:relationship_term, :to_concept_term]
    #do
    #def with_term
    #  includes(:relationship_term, :to_concept).joins(:relationship_term).select("ontology_relationship_terms.term as rel_term,
    #                                          ontology_relationships.*")
    #end
    #end

 # has_many :relationship_terms, :through => relationships

end