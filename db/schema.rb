# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20190329170642) do

  create_table "apomorphies", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "description"
    t.string "exhibited_in",   limit: 20
    t.bigint "species_id",                null: false
    t.string "character_name", limit: 20
    t.date   "created_at",                null: false
    t.bigint "user_id",                   null: false
    t.string "author",         limit: 20, null: false
    t.index ["exhibited_in"], name: "FK5097529111B1A53D", using: :btree
    t.index ["id"], name: "FK50975291D465CF79", using: :btree
    t.index ["species_id"], name: "species_fk_apomorphy_1", using: :btree
    t.index ["user_id"], name: "usr_fk_apomorphy_1", using: :btree
  end

  create_table "apomorphy_phenotypes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "apomorphy_id", null: false
    t.integer "phenotype_id", null: false
    t.index ["apomorphy_id"], name: "apomorphyphenotype_apomorphy", using: :btree
    t.index ["phenotype_id"], name: "apomorphyphenotype_phenotypes", using: :btree
  end

  create_table "apomorphy_refs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.bigint  "apomorphy_id", null: false
    t.integer "citation_id",  null: false
    t.index ["apomorphy_id"], name: "apomorphy_fk_Apomorphy_Ref_1", using: :btree
    t.index ["apomorphy_id"], name: "apomorphy_fk_apomorphy_refs_3", using: :btree
    t.index ["citation_id"], name: "citation_fk_Apomorphy_Ref_1", using: :btree
    t.index ["citation_id"], name: "citation_fk_apomorphy_refs_3", using: :btree
  end

  create_table "bioportal_ontologies", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "bioportal_id"
    t.string  "abbreviation"
    t.text    "ontology",     limit: 65535
  end

  create_table "characters", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.text     "description",       limit: 65535
    t.string   "short_name"
    t.integer  "project_id"
    t.integer  "creator_id",                                      null: false
    t.integer  "updator_id",                                      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "pos"
    t.integer  "original_position"
    t.bigint   "timeline_nid"
    t.boolean  "is_working_copy",                 default: false, null: false
    t.boolean  "is_current",                      default: false
    t.integer  "copied_from_id"
    t.string   "phenotype_type"
    t.integer  "phenotype_id"
  end

  create_table "citation_attribute_triples", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "citation_id",     null: false
    t.string  "attribute_name"
    t.string  "attribute_value"
  end

  create_table "citations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "title"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "year"
    t.string   "authors"
    t.integer  "created_by"
    t.string   "pages"
    t.string   "publisher"
    t.string   "journal"
    t.string   "article_title"
    t.string   "book_editors"
    t.string   "series_editors"
    t.string   "edition"
    t.string   "volumes"
    t.string   "city"
    t.string   "volume"
    t.string   "number"
    t.string   "isbn"
    t.string   "abstract"
    t.string   "keywords"
    t.string   "url"
    t.string   "doi"
    t.integer  "cladename_id",             null: false
    t.string   "citation_for",   limit: 0
    t.string   "type",           limit: 0
  end

  create_table "cladename_apomorphies", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.bigint "cladename_id",             null: false
    t.bigint "apomorphy_id",             null: false
    t.string "timestamp",    limit: 100
    t.index ["apomorphy_id"], name: "apo_fk_CladeName_Apomorphy_1", using: :btree
    t.index ["cladename_id"], name: "clade_fk_CladeName_Apomorphy_1", using: :btree
  end

  create_table "cladename_main_refs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.bigint  "cladename_id", null: false
    t.integer "citation_id",  null: false
    t.index ["citation_id"], name: "citation_fk_CladeName_MainRef_1", using: :btree
    t.index ["cladename_id"], name: "fk_cladename_main_refs_1", using: :btree
  end

  create_table "cladename_phyl_refs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.bigint  "cladename_id", null: false
    t.integer "citation_id",  null: false
    t.index ["citation_id"], name: "citation_fk_CladeName_PhylRef_1", using: :btree
    t.index ["cladename_id"], name: "clade_fk_CladeName_PhylRef_1", using: :btree
  end

  create_table "cladename_species", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.bigint  "cladename_id",            null: false
    t.bigint  "species_id",              null: false
    t.integer "specifier"
    t.string  "status",       limit: 40
    t.string  "timestamp",    limit: 50
    t.index ["cladename_id"], name: "clade_fk_CladeName_Species_1", using: :btree
    t.index ["species_id"], name: "species_fk_CladeName_Species_1", using: :btree
  end

  create_table "cladename_specimens", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.bigint  "cladename_id",             null: false
    t.bigint  "specimen_id",              null: false
    t.integer "specifier"
    t.string  "timestamp",    limit: 100
    t.string  "status",       limit: 30
    t.index ["cladename_id"], name: "clade_fk_CladeName_Specimen_1", using: :btree
    t.index ["cladename_id"], name: "cladename__specimens_1", using: :btree
    t.index ["specimen_id"], name: "specimen_cladespecimenfk1", using: :btree
    t.index ["specimen_id"], name: "specimen_fk_CladeName_Specimen_1", using: :btree
  end

  create_table "cladename_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.bigint "cladename_id", null: false
    t.bigint "user_id",      null: false
    t.index ["cladename_id"], name: "cladename_cladename_users_1", using: :btree
    t.index ["user_id"], name: "user_cladename_users_1", using: :btree
  end

  create_table "cladenames", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "name"
    t.bigint   "user_id"
    t.integer  "definition_type",     limit: 2
    t.string   "definition",          limit: 5000
    t.bigint   "submission_id"
    t.string   "registration_number", limit: 100
    t.string   "comments",            limit: 1000
    t.boolean  "preexisting"
    t.string   "preexisting_code"
    t.string   "preexisting_authors"
    t.boolean  "established"
    t.string   "authors"
    t.string   "guid"
    t.datetime "approved_on"
    t.string   "abbreviation"
    t.string   "name_string"
    t.index ["guid"], name: "index_cladenames_on_guid", using: :btree
    t.index ["submission_id"], name: "subb_fk_genericName_1", using: :btree
    t.index ["user_id"], name: "FK4187350214C86909", using: :btree
    t.index ["user_id"], name: "usr_fk_genericName_1", using: :btree
  end

  create_table "contributorships", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "person_id"
    t.integer  "citation_id"
    t.integer  "position"
    t.integer  "pen_name_id"
    t.boolean  "highlight"
    t.integer  "score"
    t.boolean  "hide"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["citation_id"], name: "citation_fk_contributorships_1", using: :btree
    t.index ["person_id"], name: "people_fk_contributorships_1", using: :btree
  end

  create_table "differentiae", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "property_id",                limit: 2, null: false
    t.integer "value_id",                   limit: 2, null: false
    t.string  "value_type",                           null: false
    t.integer "ontology_composition_id"
    t.integer "quality_ontology_id"
    t.integer "related_entity_ontology_id"
    t.integer "unit_ontology_id"
  end

  create_table "digital_doc_apomorphies", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.bigint  "apomorphy_id",   null: false
    t.integer "digital_doc_id"
    t.index ["apomorphy_id"], name: "apomorphy_fk_CladeName_Species_1", using: :btree
    t.index ["digital_doc_id"], name: "digital_doc_fk_image_apomorphy_1", using: :btree
  end

  create_table "digital_doc_citations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string  "linking_object_type"
    t.integer "digital_doc_id"
    t.integer "citation_id"
    t.index ["citation_id"], name: "citation_fk_digital_doc_citations_1", using: :btree
    t.index ["digital_doc_id"], name: "image_fk_image_links_1", using: :btree
  end

  create_table "digital_doc_specimens", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "digital_doc_id", null: false
    t.bigint  "specimen_id",    null: false
    t.index ["digital_doc_id"], name: "clade_fk_CladeName_Specimen_1", using: :btree
    t.index ["digital_doc_id"], name: "digital_doc_fk_image_specimen_1", using: :btree
    t.index ["specimen_id"], name: "specimen_fk_CladeName_Specimen_1", using: :btree
  end

  create_table "digital_docs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "parent_id"
    t.string   "attachment_content_type"
    t.string   "attachment_file_name"
    t.string   "thumbnail"
    t.integer  "attachment_file_size"
    t.integer  "width"
    t.integer  "height"
    t.date     "date_taken"
    t.integer  "created_by"
    t.integer  "modified_by"
    t.datetime "created_at"
    t.datetime "attachment_updated_at"
    t.index ["parent_id"], name: "images_fk_images_1", using: :btree
  end

  create_table "ontologies", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "bioportal_id",              null: false
    t.string   "label"
    t.string   "description",  limit: 1000
    t.datetime "date_created"
    t.string   "abbreviation", limit: 15
  end

  create_table "ontologies_users", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "ontology_id"
    t.integer "user_id"
  end

  create_table "ontology", primary_key: "ontology_id", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name",       limit: 32,    null: false
    t.text   "definition", limit: 65535
    t.index ["name"], name: "ontology_name_key", unique: true, using: :btree
  end

  create_table "ontology_compositions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "genus_id", null: false
  end

  create_table "ontology_concepts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "uri"
    t.string  "bioportal_id"
    t.integer "ontology_id"
    t.string  "definition",   limit: 1000
  end

  create_table "ontology_relationship_terms", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "term"
    t.boolean "super_sub"
  end

  create_table "ontology_relationships", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "from_concept_id"
    t.integer "to_concept_id"
    t.integer "relationship_term_id"
    t.index ["from_concept_id"], name: "index_ontology_relationships_on_from_concept_id", using: :btree
  end

  create_table "ontology_terms", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "term"
    t.integer "concept_id"
    t.boolean "preferred",  default: false
    t.index ["concept_id"], name: "index_ontology_terms_on_concept_id", using: :btree
  end

  create_table "people", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.integer  "exaternal_id"
    t.string   "prefix"
    t.string   "suffix"
    t.string   "image_url"
    t.string   "phone"
    t.string   "email"
    t.string   "im"
    t.string   "office_address_line_one"
    t.string   "office_address_line_two"
    t.string   "office_city"
    t.string   "office_state"
    t.string   "office_zip"
    t.string   "research_focus"
    t.boolean  "active"
    t.string   "scoring_hash"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "initials"
    t.string   "country"
    t.integer  "fax"
    t.string   "institution"
  end

  create_table "phenotypes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "phenotype_type"
    t.integer "entity_id"
    t.string  "entity_type"
    t.integer "within_entity_id"
    t.string  "within_entity_type"
    t.integer "is_present",            limit: 2
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

  create_table "preexisting_name_refs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "citation_id",         null: false
    t.bigint  "preexisting_name_id", null: false
    t.index ["citation_id"], name: "citation_fk_LegacyTaxa_Ref_1", using: :btree
    t.index ["preexisting_name_id"], name: "Taxa_fk_LegacyTaxa_Ref_1", using: :btree
  end

  create_table "preexisting_names", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "author"
    t.string "code"
    t.date   "created_at",            null: false
    t.bigint "user_id"
    t.string "name",       limit: 40, null: false
    t.index ["user_id"], name: "usr_fk_legacyTaxa_1", using: :btree
  end

  create_table "publications", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "publisher_id"
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "citations_attribute_id"
    t.integer  "user_id"
    t.integer  "updator_id"
    t.index ["publisher_id"], name: "publishers_fk_publications_1", using: :btree
  end

  create_table "publisher_sources", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "publishers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "name"
    t.integer  "sherpa_id"
    t.integer  "source_id"
    t.integer  "authority_id"
    t.boolean  "publisher_copy"
    t.string   "url"
    t.string   "romeo_color"
    t.string   "copyright_notice"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.bigint   "user_id"
    t.integer  "last_updated_by"
    t.index ["source_id"], name: "publishers_fk_publishers_1", using: :btree
    t.index ["user_id"], name: "user_fk_publishers_1", using: :btree
  end

  create_table "roles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string  "name"
    t.integer "role_id"
  end

  create_table "species", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "author"
    t.string "code"
    t.string "created_at",  limit: 20, null: false
    t.string "name",        limit: 20, null: false
    t.bigint "user_id",                null: false
    t.string "ncbi_id",     limit: 40
    t.string "ubio_id"
    t.string "treebase_id"
    t.index ["id"], name: "FK8849413CD465CF79", using: :btree
    t.index ["user_id"], name: "users_fk_species_1", using: :btree
  end

  create_table "species_refs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "citation_id", null: false
    t.bigint  "species_id",  null: false
    t.index ["citation_id"], name: "citation_fk_Species_Ref_1", using: :btree
    t.index ["species_id"], name: "species_fk_Species_Ref_1", using: :btree
  end

  create_table "specimen_refs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.bigint  "specimen_id", null: false
    t.integer "citation_id", null: false
    t.index ["citation_id"], name: "citation_fk_Specimen_Ref_1", using: :btree
    t.index ["specimen_id"], name: "specimen_fk_Specimen_Ref_1", using: :btree
  end

  create_table "specimens", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string  "author"
    t.string  "collector"
    t.string  "comment"
    t.bigint  "species_id",                    null: false
    t.integer "collection_number"
    t.string  "institutional_code", limit: 20, null: false
    t.date    "created_at",                    null: false
    t.string  "name",               limit: 20
    t.bigint  "user_id",                       null: false
    t.string  "guid"
    t.index ["id"], name: "FK80DF0308D465CF79", using: :btree
    t.index ["species_id"], name: "species_fk_specimen_1", using: :btree
    t.index ["user_id"], name: "usr_fk_specimen_1", using: :btree
  end

  create_table "states", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.text     "description",    limit: 65535
    t.integer  "character_id"
    t.string   "state"
    t.string   "polarity"
    t.integer  "creator_id",                   null: false
    t.integer  "updator_id",                   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.bigint   "citation_id"
    t.integer  "copied_from_id"
    t.string   "phenotype_type"
    t.integer  "phenotype_id"
  end

  create_table "status", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "status_id"
    t.string  "status"
  end

  create_table "status_change", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "submission_id"
    t.integer  "status_id"
    t.datetime "changed_at"
    t.string   "comments"
  end

  create_table "submission_citation_attachments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "submission_id"
    t.string   "citation_type"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.integer  "index_id"
  end

  create_table "submissions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "name"
    t.integer  "submitted_by"
    t.datetime "updated_at"
    t.datetime "submitted_at"
    t.boolean  "submitted"
    t.boolean  "establish"
    t.datetime "updated_by"
    t.integer  "status_id"
    t.text     "authors_old",         limit: 65535
    t.text     "comments",            limit: 65535
    t.boolean  "preexisting"
    t.string   "preexisting_code"
    t.string   "preexisting_authors"
    t.string   "clade_type"
    t.text     "definition",          limit: 65535
    t.text     "citations_old",       limit: 65535
    t.text     "specifiers_old",      limit: 65535
    t.string   "name_string"
    t.string   "abbreviation"
    t.string   "guid"
    t.text     "qualifying_clause",   limit: 65535
    t.text     "authors",             limit: 65535
    t.text     "citations",           limit: 65535
    t.text     "specifiers",          limit: 65535
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "email",                     limit: 100
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            limit: 40
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           limit: 40
    t.datetime "activated_at"
    t.integer  "role_id",                   limit: 2
    t.boolean  "enabled",                               default: false
    t.string   "institution",               limit: 100
    t.string   "password_hash"
    t.string   "password_salt"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "last_login"
  end

end
