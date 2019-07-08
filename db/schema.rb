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

ActiveRecord::Schema.define(version: 2019_03_31_223315) do

  create_table "active_storage_attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "apomorphies", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "description"
    t.string "exhibited_in", limit: 20
    t.bigint "species_id", null: false
    t.string "character_name", limit: 20
    t.date "created_at", null: false
    t.bigint "user_id", null: false
    t.string "author", limit: 20, null: false
    t.index ["exhibited_in"], name: "FK5097529111B1A53D"
    t.index ["id"], name: "FK50975291D465CF79"
    t.index ["species_id"], name: "species_fk_apomorphy_1"
    t.index ["user_id"], name: "usr_fk_apomorphy_1"
  end

  create_table "apomorphy_phenotypes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "apomorphy_id", null: false
    t.integer "phenotype_id", null: false
    t.index ["apomorphy_id"], name: "apomorphyphenotype_apomorphy"
    t.index ["phenotype_id"], name: "apomorphyphenotype_phenotypes"
  end

  create_table "apomorphy_refs", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "apomorphy_id", null: false
    t.integer "citation_id", null: false
    t.index ["apomorphy_id"], name: "apomorphy_fk_Apomorphy_Ref_1"
    t.index ["apomorphy_id"], name: "apomorphy_fk_apomorphy_refs_3"
    t.index ["citation_id"], name: "citation_fk_Apomorphy_Ref_1"
    t.index ["citation_id"], name: "citation_fk_apomorphy_refs_3"
  end

  create_table "bioportal_ontologies", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "bioportal_id"
    t.string "abbreviation"
    t.text "ontology"
  end

  create_table "characters", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "short_name"
    t.integer "project_id"
    t.integer "creator_id", null: false
    t.integer "updator_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "pos"
    t.integer "original_position"
    t.bigint "timeline_nid"
    t.boolean "is_working_copy", default: false, null: false
    t.boolean "is_current", default: false
    t.integer "copied_from_id"
    t.string "phenotype_type"
    t.integer "phenotype_id"
  end

  create_table "citation_attribute_triples", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "citation_id", null: false
    t.string "attribute_name"
    t.string "attribute_value"
  end

  create_table "citations", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "title"
    t.string "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "year"
    t.string "authors"
    t.integer "created_by"
    t.string "pages"
    t.string "publisher"
    t.string "journal"
    t.string "article_title"
    t.string "book_editors"
    t.string "series_editors"
    t.string "edition"
    t.string "volumes"
    t.string "city"
    t.string "volume"
    t.string "number"
    t.string "isbn"
    t.string "abstract"
    t.string "keywords"
    t.string "url"
    t.string "doi"
    t.integer "cladename_id", null: false
    t.string "citation_for", limit: 0
    t.string "type", limit: 0
  end

  create_table "cladename_apomorphies", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "cladename_id", null: false
    t.bigint "apomorphy_id", null: false
    t.string "timestamp", limit: 100
    t.index ["apomorphy_id"], name: "apo_fk_CladeName_Apomorphy_1"
    t.index ["cladename_id"], name: "clade_fk_CladeName_Apomorphy_1"
  end

  create_table "cladename_main_refs", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "cladename_id", null: false
    t.integer "citation_id", null: false
    t.index ["citation_id"], name: "citation_fk_CladeName_MainRef_1"
    t.index ["cladename_id"], name: "fk_cladename_main_refs_1"
  end

  create_table "cladename_phyl_refs", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "cladename_id", null: false
    t.integer "citation_id", null: false
    t.index ["citation_id"], name: "citation_fk_CladeName_PhylRef_1"
    t.index ["cladename_id"], name: "clade_fk_CladeName_PhylRef_1"
  end

  create_table "cladename_species", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "cladename_id", null: false
    t.bigint "species_id", null: false
    t.integer "specifier"
    t.string "status", limit: 40
    t.string "timestamp", limit: 50
    t.index ["cladename_id"], name: "clade_fk_CladeName_Species_1"
    t.index ["species_id"], name: "species_fk_CladeName_Species_1"
  end

  create_table "cladename_specimens", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "cladename_id", null: false
    t.bigint "specimen_id", null: false
    t.integer "specifier"
    t.string "timestamp", limit: 100
    t.string "status", limit: 30
    t.index ["cladename_id"], name: "clade_fk_CladeName_Specimen_1"
    t.index ["cladename_id"], name: "cladename__specimens_1"
    t.index ["specimen_id"], name: "specimen_cladespecimenfk1"
    t.index ["specimen_id"], name: "specimen_fk_CladeName_Specimen_1"
  end

  create_table "cladename_users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "cladename_id", null: false
    t.bigint "user_id", null: false
    t.index ["cladename_id"], name: "cladename_cladename_users_1"
    t.index ["user_id"], name: "user_cladename_users_1"
  end

  create_table "cladenames", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id"
    t.integer "definition_type", limit: 2
    t.string "definition", limit: 5000
    t.bigint "submission_id"
    t.string "registration_number", limit: 100
    t.string "comments", limit: 1000
    t.boolean "preexisting"
    t.string "preexisting_code"
    t.string "preexisting_authors"
    t.boolean "established"
    t.string "authors"
    t.string "guid"
    t.datetime "approved_on"
    t.string "abbreviation"
    t.string "name_string"
    t.index ["guid"], name: "index_cladenames_on_guid"
    t.index ["submission_id"], name: "subb_fk_genericName_1"
    t.index ["user_id"], name: "FK4187350214C86909"
    t.index ["user_id"], name: "usr_fk_genericName_1"
  end

  create_table "contributorships", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "person_id"
    t.integer "citation_id"
    t.integer "position"
    t.integer "pen_name_id"
    t.boolean "highlight"
    t.integer "score"
    t.boolean "hide"
    t.string "role"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["citation_id"], name: "citation_fk_contributorships_1"
    t.index ["person_id"], name: "people_fk_contributorships_1"
  end

  create_table "differentiae", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "property_id", limit: 2, null: false
    t.integer "value_id", limit: 2, null: false
    t.string "value_type", null: false
    t.integer "ontology_composition_id"
    t.integer "quality_ontology_id"
    t.integer "related_entity_ontology_id"
    t.integer "unit_ontology_id"
  end

  create_table "digital_doc_apomorphies", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "apomorphy_id", null: false
    t.integer "digital_doc_id"
    t.index ["apomorphy_id"], name: "apomorphy_fk_CladeName_Species_1"
    t.index ["digital_doc_id"], name: "digital_doc_fk_image_apomorphy_1"
  end

  create_table "digital_doc_citations", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "linking_object_type"
    t.integer "digital_doc_id"
    t.integer "citation_id"
    t.index ["citation_id"], name: "citation_fk_digital_doc_citations_1"
    t.index ["digital_doc_id"], name: "image_fk_image_links_1"
  end

  create_table "digital_doc_specimens", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "digital_doc_id", null: false
    t.bigint "specimen_id", null: false
    t.index ["digital_doc_id"], name: "clade_fk_CladeName_Specimen_1"
    t.index ["digital_doc_id"], name: "digital_doc_fk_image_specimen_1"
    t.index ["specimen_id"], name: "specimen_fk_CladeName_Specimen_1"
  end

  create_table "digital_docs", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "parent_id"
    t.string "attachment_content_type"
    t.string "attachment_file_name"
    t.string "thumbnail"
    t.integer "attachment_file_size"
    t.integer "width"
    t.integer "height"
    t.date "date_taken"
    t.integer "created_by"
    t.integer "modified_by"
    t.datetime "created_at"
    t.datetime "attachment_updated_at"
    t.index ["parent_id"], name: "images_fk_images_1"
  end

  create_table "ontologies", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "bioportal_id", null: false
    t.string "label"
    t.string "description", limit: 1000
    t.datetime "date_created"
    t.string "abbreviation", limit: 15
  end

  create_table "ontologies_users", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "ontology_id"
    t.integer "user_id"
  end

  create_table "ontology", primary_key: "ontology_id", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 32, null: false
    t.text "definition"
    t.index ["name"], name: "ontology_name_key", unique: true
  end

  create_table "ontology_compositions", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "genus_id", null: false
  end

  create_table "ontology_concepts", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "uri"
    t.string "bioportal_id"
    t.integer "ontology_id"
    t.string "definition", limit: 1000
  end

  create_table "ontology_relationship_terms", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "term"
    t.boolean "super_sub"
  end

  create_table "ontology_relationships", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "from_concept_id"
    t.integer "to_concept_id"
    t.integer "relationship_term_id"
    t.index ["from_concept_id"], name: "index_ontology_relationships_on_from_concept_id"
  end

  create_table "ontology_terms", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "term"
    t.integer "concept_id"
    t.boolean "preferred", default: false
    t.index ["concept_id"], name: "index_ontology_terms_on_concept_id"
  end

  create_table "people", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.integer "exaternal_id"
    t.string "prefix"
    t.string "suffix"
    t.string "image_url"
    t.string "phone"
    t.string "email"
    t.string "im"
    t.string "office_address_line_one"
    t.string "office_address_line_two"
    t.string "office_city"
    t.string "office_state"
    t.string "office_zip"
    t.string "research_focus"
    t.boolean "active"
    t.string "scoring_hash"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "initials"
    t.string "country"
    t.integer "fax"
    t.string "institution"
  end

  create_table "phenotypes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "phenotype_type"
    t.integer "entity_id"
    t.string "entity_type"
    t.integer "within_entity_id"
    t.string "within_entity_type"
    t.integer "is_present", limit: 2
    t.integer "minimum"
    t.integer "maximum"
    t.integer "quality_id"
    t.string "quality_type"
    t.integer "dependent_entity_id"
    t.string "dependent_entity_type"
    t.integer "unit_id"
    t.integer "count"
    t.integer "state_id"
  end

  create_table "preexisting_name_refs", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "citation_id", null: false
    t.bigint "preexisting_name_id", null: false
    t.index ["citation_id"], name: "citation_fk_LegacyTaxa_Ref_1"
    t.index ["preexisting_name_id"], name: "Taxa_fk_LegacyTaxa_Ref_1"
  end

  create_table "preexisting_names", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "author"
    t.string "code"
    t.date "created_at", null: false
    t.bigint "user_id"
    t.string "name", limit: 40, null: false
    t.index ["user_id"], name: "usr_fk_legacyTaxa_1"
  end

  create_table "publications", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "publisher_id"
    t.string "name"
    t.string "code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "citations_attribute_id"
    t.integer "user_id"
    t.integer "updator_id"
    t.index ["publisher_id"], name: "publishers_fk_publications_1"
  end

  create_table "publisher_sources", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "publishers", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.integer "sherpa_id"
    t.integer "source_id"
    t.integer "authority_id"
    t.boolean "publisher_copy"
    t.string "url"
    t.string "romeo_color"
    t.string "copyright_notice"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.bigint "user_id"
    t.integer "last_updated_by"
    t.index ["source_id"], name: "publishers_fk_publishers_1"
    t.index ["user_id"], name: "user_fk_publishers_1"
  end

  create_table "roles", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.integer "role_id"
  end

  create_table "species", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "author"
    t.string "code"
    t.string "created_at", limit: 20, null: false
    t.string "name", limit: 20, null: false
    t.bigint "user_id", null: false
    t.string "ncbi_id", limit: 40
    t.string "ubio_id"
    t.string "treebase_id"
    t.index ["id"], name: "FK8849413CD465CF79"
    t.index ["user_id"], name: "users_fk_species_1"
  end

  create_table "species_refs", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "citation_id", null: false
    t.bigint "species_id", null: false
    t.index ["citation_id"], name: "citation_fk_Species_Ref_1"
    t.index ["species_id"], name: "species_fk_Species_Ref_1"
  end

  create_table "specimen_refs", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.bigint "specimen_id", null: false
    t.integer "citation_id", null: false
    t.index ["citation_id"], name: "citation_fk_Specimen_Ref_1"
    t.index ["specimen_id"], name: "specimen_fk_Specimen_Ref_1"
  end

  create_table "specimens", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "author"
    t.string "collector"
    t.string "comment"
    t.bigint "species_id", null: false
    t.integer "collection_number"
    t.string "institutional_code", limit: 20, null: false
    t.date "created_at", null: false
    t.string "name", limit: 20
    t.bigint "user_id", null: false
    t.string "guid"
    t.index ["id"], name: "FK80DF0308D465CF79"
    t.index ["species_id"], name: "species_fk_specimen_1"
    t.index ["user_id"], name: "usr_fk_specimen_1"
  end

  create_table "states", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "character_id"
    t.string "state"
    t.string "polarity"
    t.integer "creator_id", null: false
    t.integer "updator_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.bigint "citation_id"
    t.integer "copied_from_id"
    t.string "phenotype_type"
    t.integer "phenotype_id"
  end

  create_table "status", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "status_id"
    t.string "status"
  end

  create_table "status_change", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "submission_id"
    t.integer "status_id"
    t.datetime "changed_at"
    t.string "comments"
  end

  create_table "submission_citation_attachments", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "submission_id"
    t.string "citation_type"
    t.string "file_file_name"
    t.string "file_content_type"
    t.integer "file_file_size"
    t.datetime "file_updated_at"
    t.integer "index_id"
  end

  create_table "submissions", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.integer "submitted_by"
    t.datetime "updated_at"
    t.datetime "submitted_at"
    t.boolean "submitted"
    t.boolean "establish"
    t.datetime "updated_by"
    t.integer "status_id"
    t.text "authors_old"
    t.text "comments"
    t.boolean "preexisting"
    t.string "preexisting_code"
    t.string "preexisting_authors"
    t.string "clade_type"
    t.text "definition"
    t.text "citations_old"
    t.text "specifiers_old"
    t.string "name_string"
    t.string "abbreviation"
    t.string "guid"
    t.text "qualifying_clause"
    t.text "authors"
    t.text "citations"
    t.text "specifiers"
  end

  create_table "users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "email", limit: 100
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "remember_token", limit: 40
    t.datetime "remember_token_expires_at"
    t.string "activation_code", limit: 40
    t.datetime "activated_at"
    t.integer "role_id", limit: 2
    t.boolean "enabled", default: false
    t.string "institution", limit: 100
    t.string "password_hash"
    t.string "password_salt"
    t.string "first_name"
    t.string "last_name"
    t.datetime "last_login"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
end
