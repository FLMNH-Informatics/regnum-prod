class CreateImagelinks < ActiveRecord::Migration
  def self.up
     create_table "images", :force => true do |t|
    t.integer  "parent_id"
    t.string   "content_type"
    t.string   "filename"
    t.string   "thumbnail"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.date     "date_taken"
    t.integer  "created_by"
    t.integer  "modified_by"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

   create_table "image_links", :force => true do |t|
    t.integer "linking_object_id"
    t.string  "linking_object_type"
    t.integer "image_id"
  end
  end

  def self.down
  end
end
