class CreateCitationsPublications < ActiveRecord::Migration
  def self.up
    create_table "publications", :force => true do |t|
    t.integer  "sherpa_id"
    t.integer  "publisher_id"
    t.integer  "source_id"
    t.integer  "authority_id"
    t.string   "name"
    t.string   "url"
    t.string   "code"
    t.string   "issn_isbn"
    t.string   "place"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
  end
  end

  def self.down
    drop_table :citations_publications
  end
end
