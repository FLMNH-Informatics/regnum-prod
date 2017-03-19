class AddMorePhenoTables < ActiveRecord::Migration
  def self.up
  	drop_table "differentiae"
  	drop_table "ontology_compositions"
  	drop_table "ontology_terms"
  	drop_table "phenotypes"

		create_table "characters", :force => true do |t|
	    t.string   "name"
	    t.text     "description"
	    t.string   "short_name"
	    t.integer  "project_id"
	    t.integer  "creator_id",                                        :null => false
	    t.integer  "updator_id",                                        :null => false
	    t.datetime "created_at"
	    t.datetime "updated_at"
	    t.integer  "pos"
	    t.integer  "original_position"
	    t.integer  "timeline_nid",      :limit => 8
	    t.boolean  "is_working_copy",                :default => false, :null => false
	    t.boolean  "is_current",                     :default => false
	    t.integer  "copied_from_id"
	    t.string   "phenotype_type"
	    t.integer  "phenotype_id"
	  end

	  create_table "differentiae", :force => true do |t|
	    t.integer "property_id",                :limit => 2, :null => false
	    t.integer "value_id",                   :limit => 2, :null => false
	    t.string  "value_type",                              :null => false
	    t.integer "ontology_composition_id"
	    t.integer "quality_ontology_id"
	    t.integer "related_entity_ontology_id"
	    t.integer "unit_ontology_id"
	  end

	  create_table "ontologies", :force => true do |t|
	    t.integer  "bioportal_id",                 :null => false
	    t.string   "label"
	    t.string   "description",  :limit => 1000
	    t.datetime "date_created"
	    t.string   "abbreviation", :limit => 15
	  end

	  create_table "ontologies_users", :id => false, :force => true do |t|
	    t.integer "ontology_id"
	    t.integer "user_id"
	  end

	  create_table "ontology", :primary_key => "ontology_id", :force => true do |t|
	    t.string "name",       :limit => 32, :null => false
	    t.text   "definition"
	  end

	  add_index "ontology", ["name"], :name => "ontology_name_key", :unique => true

	  create_table "ontology_compositions", :force => true do |t|
	    t.integer "genus_id", :null => false
	  end

	  create_table "ontology_concepts", :force => true do |t|
	    t.string  "uri"
	    t.string  "bioportal_id"
	    t.integer "ontology_id"
	    t.string  "definition",   :limit => 1000
	  end

	  create_table "ontology_relationship_terms", :force => true do |t|
	    t.string  "term"
	    t.boolean "super_sub"
	  end

	  create_table "ontology_relationships", :force => true do |t|
	    t.integer "from_concept_id"
	    t.integer "to_concept_id"
	    t.integer "relationship_term_id"
	  end

	  add_index "ontology_relationships", ["from_concept_id"], :name => "index_ontology_relationships_on_from_concept_id"

	  create_table "ontology_terms", :force => true do |t|
	    t.string  "term"
	    t.integer "concept_id"
	    t.boolean "preferred",  :default => false
	  end

	  add_index "ontology_terms", ["concept_id"], :name => "index_ontology_terms_on_concept_id"

	  create_table "phenotypes", :force => true do |t|
	    t.string  "phenotype_type"
	    t.integer "entity_id"
	    t.string  "entity_type"
	    t.integer "within_entity_id"
	    t.string  "within_entity_type"
	    t.integer "is_present",            :limit => 2
	    t.integer "minimum"
	    t.integer "maximum"
	    t.integer "quality_id"
	    t.string  "quality_type"
	    t.integer "dependent_entity_id"
	    t.string  "dependent_entity_type"
	    t.integer "unit_id"
	    t.integer "count"
	    t.integer "state_id"
	  end

	  create_table "states", :force => true do |t|
	    t.string   "name"
	    t.text     "description"
	    t.integer  "character_id"
	    t.string   "state"
	    t.string   "polarity"
	    t.integer  "creator_id",                  :null => false
	    t.integer  "updator_id",                  :null => false
	    t.datetime "created_at"
	    t.datetime "updated_at"
	    t.integer  "citation_id",    :limit => 8
	    t.integer  "copied_from_id"
	    t.string   "phenotype_type"
	    t.integer  "phenotype_id"
	  end
  end

  def self.down
  end
end
