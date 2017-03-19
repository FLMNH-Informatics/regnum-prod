class BioportalOntology < ActiveRecord::Base
  self.table_name = 'bioportal_ontologies'
  serialize :ontology, Hash

  def self.synchronize_ontologies
     ontologies = Remote::Bioportal::Ontology.offset(0).all_synchronize({})
     ontologies.each do |ont|
       #deprecated in rails 4
       # o = self.find_or_create_by_bioportal_id(:bioportal_id => ont[:bioportal_id], :abbreviation => ont[:abbreviation], :ontology => ont)
       #replace with
       o = self.find_or_create_by(:bioportal_id => ont[:bioportal_id], :abbreviation => ont[:abbreviation], :ontology => ont)
       o.save
     end
  end
   
end