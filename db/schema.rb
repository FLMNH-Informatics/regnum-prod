# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20190204194315) do

  create_table "apomorphies", force: :cascade do |t|
    t.string  "description",    limit: 255
    t.string  "exhibited_in",   limit: 20
    t.integer "species_id",     limit: 8,   null: false
    t.string  "character_name", limit: 20
    t.date    "created_at",                 null: false
    t.integer "user_id",        limit: 8,   null: false
    t.string  "author",         limit: 20,  null: false
  end

  add_index "apomorphies", ["exhibited_in"], name: "FK5097529111B1A53D", using: :btree
  add_index "apomorphies", ["id"], name: "FK50975291D465CF79", using: :btree
  add_index "apomorphies", ["species_id"], name: "species_fk_apomorphy_1", using: :btree
  add_index "apomorphies", ["user_id"], name: "usr_fk_apomorphy_1", using: :btree

  create_table "apomorphy_phenotypes", force: :cascade do |t|
    t.integer "apomorphy_id", limit: 4, null: false
    t.integer "phenotype_id", limit: 4, null: false
  end

  add_index "apomorphy_phenotypes", ["apomorphy_id"], name: "apomorphyphenotype_apomorphy", using: :btree
  add_index "apomorphy_phenotypes", ["phenotype_id"], name: "apomorphyphenotype_phenotypes", using: :btree

  create_table "apomorphy_refs", force: :cascade do |t|
    t.integer "apomorphy_id", limit: 8, null: false
    t.integer "citation_id",  limit: 4, null: false
  end

  add_index "apomorphy_refs", ["apomorphy_id"], name: "apomorphy_fk_Apomorphy_Ref_1", using: :btree
  add_index "apomorphy_refs", ["apomorphy_id"], name: "apomorphy_fk_apomorphy_refs_3", using: :btree
  add_index "apomorphy_refs", ["citation_id"], name: "citation_fk_Apomorphy_Ref_1", using: :btree
  add_index "apomorphy_refs", ["citation_id"], name: "citation_fk_apomorphy_refs_3", using: :btree

  create_table "ar_internal_metadata", primary_key: "key", force: :cascade do |t|
    t.string   "value",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "bioportal_ontologies", force: :cascade do |t|
    t.integer "bioportal_id", limit: 4
    t.string  "abbreviation", limit: 255
    t.text    "ontology",     limit: 65535
  end

  create_table "characters", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.text     "description",       limit: 65535
    t.string   "short_name",        limit: 255
    t.integer  "project_id",        limit: 4
    t.integer  "creator_id",        limit: 4,                     null: false
    t.integer  "updator_id",        limit: 4,                     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "pos",               limit: 4
    t.integer  "original_position", limit: 4
    t.integer  "timeline_nid",      limit: 8
    t.boolean  "is_working_copy",                 default: false, null: false
    t.boolean  "is_current",                      default: false
    t.integer  "copied_from_id",    limit: 4
    t.string   "phenotype_type",    limit: 255
    t.integer  "phenotype_id",      limit: 4
  end

  create_table "citation_attribute_triples", force: :cascade do |t|
    t.integer "citation_id",     limit: 4,   null: false
    t.string  "attribute_name",  limit: 255
    t.string  "attribute_value", limit: 255
  end

  create_table "citations", force: :cascade do |t|
    t.string   "title",          limit: 255
    t.string   "updated_by",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "year",           limit: 4
    t.string   "authors",        limit: 255
    t.integer  "created_by",     limit: 4
    t.string   "pages",          limit: 255
    t.string   "publisher",      limit: 255
    t.string   "journal",        limit: 255
    t.string   "article_title",  limit: 255
    t.string   "book_editors",   limit: 255
    t.string   "series_editors", limit: 255
    t.string   "edition",        limit: 255
    t.string   "volumes",        limit: 255
    t.string   "city",           limit: 255
    t.string   "volume",         limit: 255
    t.string   "number",         limit: 255
    t.string   "isbn",           limit: 255
    t.string   "abstract",       limit: 255
    t.string   "keywords",       limit: 255
    t.string   "url",            limit: 255
    t.string   "doi",            limit: 255
    t.integer  "cladename_id",   limit: 4,   null: false
    t.string   "citation_for",   limit: 0
    t.string   "type",           limit: 0
  end

  create_table "cladename_apomorphies", force: :cascade do |t|
    t.integer "cladename_id", limit: 8,   null: false
    t.integer "apomorphy_id", limit: 8,   null: false
    t.string  "timestamp",    limit: 100
  end

  add_index "cladename_apomorphies", ["apomorphy_id"], name: "apo_fk_CladeName_Apomorphy_1", using: :btree
  add_index "cladename_apomorphies", ["cladename_id"], name: "clade_fk_CladeName_Apomorphy_1", using: :btree

  create_table "cladename_main_refs", force: :cascade do |t|
    t.integer "cladename_id", limit: 8, null: false
    t.integer "citation_id",  limit: 4, null: false
  end

  add_index "cladename_main_refs", ["citation_id"], name: "citation_fk_CladeName_MainRef_1", using: :btree
  add_index "cladename_main_refs", ["cladename_id"], name: "fk_cladename_main_refs_1", using: :btree

  create_table "cladename_phyl_refs", force: :cascade do |t|
    t.integer "cladename_id", limit: 8, null: false
    t.integer "citation_id",  limit: 4, null: false
  end

  add_index "cladename_phyl_refs", ["citation_id"], name: "citation_fk_CladeName_PhylRef_1", using: :btree
  add_index "cladename_phyl_refs", ["cladename_id"], name: "clade_fk_CladeName_PhylRef_1", using: :btree

  create_table "cladename_species", force: :cascade do |t|
    t.integer "cladename_id", limit: 8,  null: false
    t.integer "species_id",   limit: 8,  null: false
    t.integer "specifier",    limit: 4
    t.string  "status",       limit: 40
    t.string  "timestamp",    limit: 50
  end

  add_index "cladename_species", ["cladename_id"], name: "clade_fk_CladeName_Species_1", using: :btree
  add_index "cladename_species", ["species_id"], name: "species_fk_CladeName_Species_1", using: :btree

  create_table "cladename_specimens", force: :cascade do |t|
    t.integer "cladename_id", limit: 8,   null: false
    t.integer "specimen_id",  limit: 8,   null: false
    t.integer "specifier",    limit: 4
    t.string  "timestamp",    limit: 100
    t.string  "status",       limit: 30
  end

  add_index "cladename_specimens", ["cladename_id"], name: "clade_fk_CladeName_Specimen_1", using: :btree
  add_index "cladename_specimens", ["cladename_id"], name: "cladename__specimens_1", using: :btree
  add_index "cladename_specimens", ["specimen_id"], name: "specimen_cladespecimenfk1", using: :btree
  add_index "cladename_specimens", ["specimen_id"], name: "specimen_fk_CladeName_Specimen_1", using: :btree

  create_table "cladename_users", force: :cascade do |t|
    t.integer "cladename_id", limit: 8, null: false
    t.integer "user_id",      limit: 8, null: false
  end

  add_index "cladename_users", ["cladename_id"], name: "cladename_cladename_users_1", using: :btree
  add_index "cladename_users", ["user_id"], name: "user_cladename_users_1", using: :btree

  create_table "cladenames", force: :cascade do |t|
    t.string   "name",                limit: 255
    t.integer  "user_id",             limit: 8
    t.integer  "definition_type",     limit: 2
    t.string   "definition",          limit: 5000
    t.integer  "submission_id",       limit: 8
    t.string   "registration_number", limit: 100
    t.string   "comments",            limit: 1000
    t.boolean  "preexisting"
    t.string   "preexisting_code",    limit: 255
    t.string   "preexisting_authors", limit: 255
    t.boolean  "established"
    t.string   "authors",             limit: 255
    t.string   "guid",                limit: 255
    t.datetime "approved_on"
    t.string   "abbreviation",        limit: 255
    t.string   "name_string",         limit: 255
  end

  add_index "cladenames", ["guid"], name: "index_cladenames_on_guid", using: :btree
  add_index "cladenames", ["submission_id"], name: "subb_fk_genericName_1", using: :btree
  add_index "cladenames", ["user_id"], name: "FK4187350214C86909", using: :btree
  add_index "cladenames", ["user_id"], name: "usr_fk_genericName_1", using: :btree

  create_table "contributorships", force: :cascade do |t|
    t.integer  "person_id",   limit: 4
    t.integer  "citation_id", limit: 4
    t.integer  "position",    limit: 4
    t.integer  "pen_name_id", limit: 4
    t.boolean  "highlight"
    t.integer  "score",       limit: 4
    t.boolean  "hide"
    t.string   "role",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contributorships", ["citation_id"], name: "citation_fk_contributorships_1", using: :btree
  add_index "contributorships", ["person_id"], name: "people_fk_contributorships_1", using: :btree

  create_table "differentiae", force: :cascade do |t|
    t.integer "property_id",                limit: 2,   null: false
    t.integer "value_id",                   limit: 2,   null: false
    t.string  "value_type",                 limit: 255, null: false
    t.integer "ontology_composition_id",    limit: 4
    t.integer "quality_ontology_id",        limit: 4
    t.integer "related_entity_ontology_id", limit: 4
    t.integer "unit_ontology_id",           limit: 4
  end

  create_table "digital_doc_apomorphies", force: :cascade do |t|
    t.integer "apomorphy_id",   limit: 8, null: false
    t.integer "digital_doc_id", limit: 4
  end

  add_index "digital_doc_apomorphies", ["apomorphy_id"], name: "apomorphy_fk_CladeName_Species_1", using: :btree
  add_index "digital_doc_apomorphies", ["digital_doc_id"], name: "digital_doc_fk_image_apomorphy_1", using: :btree

  create_table "digital_doc_citations", force: :cascade do |t|
    t.string  "linking_object_type", limit: 255
    t.integer "digital_doc_id",      limit: 4
    t.integer "citation_id",         limit: 4
  end

  add_index "digital_doc_citations", ["citation_id"], name: "citation_fk_digital_doc_citations_1", using: :btree
  add_index "digital_doc_citations", ["digital_doc_id"], name: "image_fk_image_links_1", using: :btree

  create_table "digital_doc_specimens", force: :cascade do |t|
    t.integer "digital_doc_id", limit: 4, null: false
    t.integer "specimen_id",    limit: 8, null: false
  end

  add_index "digital_doc_specimens", ["digital_doc_id"], name: "clade_fk_CladeName_Specimen_1", using: :btree
  add_index "digital_doc_specimens", ["digital_doc_id"], name: "digital_doc_fk_image_specimen_1", using: :btree
  add_index "digital_doc_specimens", ["specimen_id"], name: "specimen_fk_CladeName_Specimen_1", using: :btree

  create_table "digital_docs", force: :cascade do |t|
    t.integer  "parent_id",               limit: 4
    t.string   "attachment_content_type", limit: 255
    t.string   "attachment_file_name",    limit: 255
    t.string   "thumbnail",               limit: 255
    t.integer  "attachment_file_size",    limit: 4
    t.integer  "width",                   limit: 4
    t.integer  "height",                  limit: 4
    t.date     "date_taken"
    t.integer  "created_by",              limit: 4
    t.integer  "modified_by",             limit: 4
    t.datetime "created_at"
    t.datetime "attachment_updated_at"
  end

  add_index "digital_docs", ["parent_id"], name: "images_fk_images_1", using: :btree

  create_table "ontologies", force: :cascade do |t|
    t.integer  "bioportal_id", limit: 4,    null: false
    t.string   "label",        limit: 255
    t.string   "description",  limit: 1000
    t.datetime "date_created"
    t.string   "abbreviation", limit: 15
  end

  create_table "ontologies_users", id: false, force: :cascade do |t|
    t.integer "ontology_id", limit: 4
    t.integer "user_id",     limit: 4
  end

  create_table "ontology", primary_key: "ontology_id", force: :cascade do |t|
    t.string "name",       limit: 32,    null: false
    t.text   "definition", limit: 65535
  end

  add_index "ontology", ["name"], name: "ontology_name_key", unique: true, using: :btree

  create_table "ontology_compositions", force: :cascade do |t|
    t.integer "genus_id", limit: 4, null: false
  end

  create_table "ontology_concepts", force: :cascade do |t|
    t.string  "uri",          limit: 255
    t.string  "bioportal_id", limit: 255
    t.integer "ontology_id",  limit: 4
    t.string  "definition",   limit: 1000
  end

  create_table "ontology_relationship_terms", force: :cascade do |t|
    t.string  "term",      limit: 255
    t.boolean "super_sub"
  end

  create_table "ontology_relationships", force: :cascade do |t|
    t.integer "from_concept_id",      limit: 4
    t.integer "to_concept_id",        limit: 4
    t.integer "relationship_term_id", limit: 4
  end

  add_index "ontology_relationships", ["from_concept_id"], name: "index_ontology_relationships_on_from_concept_id", using: :btree

  create_table "ontology_terms", force: :cascade do |t|
    t.string  "term",       limit: 255
    t.integer "concept_id", limit: 4
    t.boolean "preferred",              default: false
  end

  add_index "ontology_terms", ["concept_id"], name: "index_ontology_terms_on_concept_id", using: :btree

  create_table "people", force: :cascade do |t|
    t.string   "first_name",              limit: 255
    t.string   "middle_name",             limit: 255
    t.string   "last_name",               limit: 255
    t.integer  "exaternal_id",            limit: 4
    t.string   "prefix",                  limit: 255
    t.string   "suffix",                  limit: 255
    t.string   "image_url",               limit: 255
    t.string   "phone",                   limit: 255
    t.string   "email",                   limit: 255
    t.string   "im",                      limit: 255
    t.string   "office_address_line_one", limit: 255
    t.string   "office_address_line_two", limit: 255
    t.string   "office_city",             limit: 255
    t.string   "office_state",            limit: 255
    t.string   "office_zip",              limit: 255
    t.string   "research_focus",          limit: 255
    t.boolean  "active"
    t.string   "scoring_hash",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "initials",                limit: 255
    t.string   "country",                 limit: 255
    t.integer  "fax",                     limit: 4
    t.string   "institution",             limit: 255
  end

  create_table "phenotypes", force: :cascade do |t|
    t.string  "phenotype_type",        limit: 255
    t.integer "entity_id",             limit: 4
    t.string  "entity_type",           limit: 255
    t.integer "within_entity_id",      limit: 4
    t.string  "within_entity_type",    limit: 255
    t.integer "is_present",            limit: 2
    t.integer "minimum",               limit: 4
    t.integer "maximum",               limit: 4
    t.integer "quality_id",            limit: 4
    t.string  "quality_type",          limit: 255
    t.integer "dependent_entity_id",   limit: 4
    t.string  "dependent_entity_type", limit: 255
    t.integer "unit_id",               limit: 4
    t.integer "count",                 limit: 4
    t.integer "state_id",              limit: 4
  end

  create_table "preexisting_name_refs", force: :cascade do |t|
    t.integer "citation_id",         limit: 4, null: false
    t.integer "preexisting_name_id", limit: 8, null: false
  end

  add_index "preexisting_name_refs", ["citation_id"], name: "citation_fk_LegacyTaxa_Ref_1", using: :btree
  add_index "preexisting_name_refs", ["preexisting_name_id"], name: "Taxa_fk_LegacyTaxa_Ref_1", using: :btree

  create_table "preexisting_names", force: :cascade do |t|
    t.string  "author",     limit: 255
    t.string  "code",       limit: 255
    t.date    "created_at",             null: false
    t.integer "user_id",    limit: 8
    t.string  "name",       limit: 40,  null: false
  end

  add_index "preexisting_names", ["user_id"], name: "usr_fk_legacyTaxa_1", using: :btree

  create_table "publications", force: :cascade do |t|
    t.integer  "publisher_id",           limit: 4
    t.string   "name",                   limit: 255
    t.string   "code",                   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "citations_attribute_id", limit: 4
    t.integer  "user_id",                limit: 4
    t.integer  "updator_id",             limit: 4
  end

  add_index "publications", ["publisher_id"], name: "publishers_fk_publications_1", using: :btree

  create_table "publisher_sources", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "publishers", force: :cascade do |t|
    t.string   "name",             limit: 255
    t.integer  "sherpa_id",        limit: 4
    t.integer  "source_id",        limit: 4
    t.integer  "authority_id",     limit: 4
    t.boolean  "publisher_copy"
    t.string   "url",              limit: 255
    t.string   "romeo_color",      limit: 255
    t.string   "copyright_notice", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",          limit: 8
    t.integer  "last_updated_by",  limit: 4
  end

  add_index "publishers", ["source_id"], name: "publishers_fk_publishers_1", using: :btree
  add_index "publishers", ["user_id"], name: "user_fk_publishers_1", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string  "name",    limit: 255
    t.integer "role_id", limit: 4
  end

  create_table "species", force: :cascade do |t|
    t.string  "author",      limit: 255
    t.string  "code",        limit: 255
    t.string  "created_at",  limit: 20,  null: false
    t.string  "name",        limit: 20,  null: false
    t.integer "user_id",     limit: 8,   null: false
    t.string  "ncbi_id",     limit: 40
    t.string  "ubio_id",     limit: 255
    t.string  "treebase_id", limit: 255
  end

  add_index "species", ["id"], name: "FK8849413CD465CF79", using: :btree
  add_index "species", ["user_id"], name: "users_fk_species_1", using: :btree

  create_table "species_refs", force: :cascade do |t|
    t.integer "citation_id", limit: 4, null: false
    t.integer "species_id",  limit: 8, null: false
  end

  add_index "species_refs", ["citation_id"], name: "citation_fk_Species_Ref_1", using: :btree
  add_index "species_refs", ["species_id"], name: "species_fk_Species_Ref_1", using: :btree

  create_table "specimen_refs", force: :cascade do |t|
    t.integer "specimen_id", limit: 8, null: false
    t.integer "citation_id", limit: 4, null: false
  end

  add_index "specimen_refs", ["citation_id"], name: "citation_fk_Specimen_Ref_1", using: :btree
  add_index "specimen_refs", ["specimen_id"], name: "specimen_fk_Specimen_Ref_1", using: :btree

  create_table "specimens", force: :cascade do |t|
    t.string  "author",             limit: 255
    t.string  "collector",          limit: 255
    t.string  "comment",            limit: 255
    t.integer "species_id",         limit: 8,   null: false
    t.integer "collection_number",  limit: 4
    t.string  "institutional_code", limit: 20,  null: false
    t.date    "created_at",                     null: false
    t.string  "name",               limit: 20
    t.integer "user_id",            limit: 8,   null: false
    t.string  "guid",               limit: 255
  end

  add_index "specimens", ["id"], name: "FK80DF0308D465CF79", using: :btree
  add_index "specimens", ["species_id"], name: "species_fk_specimen_1", using: :btree
  add_index "specimens", ["user_id"], name: "usr_fk_specimen_1", using: :btree

  create_table "states", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.text     "description",    limit: 65535
    t.integer  "character_id",   limit: 4
    t.string   "state",          limit: 255
    t.string   "polarity",       limit: 255
    t.integer  "creator_id",     limit: 4,     null: false
    t.integer  "updator_id",     limit: 4,     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "citation_id",    limit: 8
    t.integer  "copied_from_id", limit: 4
    t.string   "phenotype_type", limit: 255
    t.integer  "phenotype_id",   limit: 4
  end

  create_table "status", force: :cascade do |t|
    t.integer "status_id", limit: 4
    t.string  "status",    limit: 255
  end

  create_table "status_change", force: :cascade do |t|
    t.integer  "submission_id", limit: 4
    t.integer  "status_id",     limit: 4
    t.datetime "changed_at"
    t.string   "comments",      limit: 255
  end

  create_table "submission_citation_attachments", force: :cascade do |t|
    t.integer  "submission_id",     limit: 4
    t.string   "citation_type",     limit: 255
    t.string   "file_file_name",    limit: 255
    t.string   "file_content_type", limit: 255
    t.integer  "file_file_size",    limit: 4
    t.datetime "file_updated_at"
    t.integer  "index_id",          limit: 4
  end

  create_table "submissions", force: :cascade do |t|
    t.string   "name",                limit: 255
    t.integer  "submitted_by",        limit: 4
    t.datetime "updated_at"
    t.datetime "submitted_at"
    t.boolean  "submitted"
    t.boolean  "establish"
    t.datetime "updated_by"
    t.integer  "status_id",           limit: 4
    t.text     "authors",             limit: 65535
    t.text     "comments",            limit: 65535
    t.boolean  "preexisting"
    t.string   "preexisting_code",    limit: 255
    t.string   "preexisting_authors", limit: 255
    t.string   "clade_type",          limit: 255
    t.text     "definition",          limit: 65535
    t.text     "citations",           limit: 65535
    t.text     "specifiers",          limit: 65535
    t.string   "name_string",         limit: 255
    t.string   "abbreviation",        limit: 255
    t.string   "guid",                limit: 255
    t.text     "qualifying_clause",   limit: 65535
  end

  create_table "users", force: :cascade do |t|
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
    t.string   "password_hash",             limit: 255
    t.string   "password_salt",             limit: 255
    t.string   "first_name",                limit: 255
    t.string   "last_name",                 limit: 255
    t.datetime "last_login"
  end

end
