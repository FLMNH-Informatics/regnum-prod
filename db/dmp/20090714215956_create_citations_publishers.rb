class CreateCitationsPublishers < ActiveRecord::Migration
  def self.up
    create_table "publishers", :force => true do |t|
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
    t.integer  "project_id"
    t.integer  "user_id"
    t.integer  "last_updated_by"
  end
  end

  def self.down
    drop_table :citations_publishers
  end
end
