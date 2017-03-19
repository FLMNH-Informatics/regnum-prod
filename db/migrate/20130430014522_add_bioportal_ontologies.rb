class AddBioportalOntologies < ActiveRecord::Migration
  def self.up
  	create_table :bioportal_ontologies do |t|
      t.integer :bioportal_id
      t.string :abbreviation
      t.text :ontology
  	end
  end

  def self.down
  end
end
