class CreateCitationsPenNames < ActiveRecord::Migration
  def self.up
     create_table "pen_names", :force => true do |t|
    t.integer  "name_string_id"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
  end

  def self.down
    drop_table :citations_pen_names
  end
end
