class CreateCitationsContributorships < ActiveRecord::Migration
  def self.up
    create_table "contributorships", :force => true do |t|
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
  end
  end

  def self.down
    drop_table :citations_contributorships
  end
end
