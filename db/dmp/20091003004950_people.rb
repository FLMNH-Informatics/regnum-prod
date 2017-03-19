class People < ActiveRecord::Migration
  def self.up
     create_table "people", :force => true do |t|
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
    t.integer  "project_id"
    t.integer  "user_id"
    t.string   "initials"
    t.string   "country"
    t.integer  "fax"
    t.string   "institution"
  end
  end

  def self.down
    drop_table :people
  end
end
