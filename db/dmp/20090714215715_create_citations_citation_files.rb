class CreateCitationsCitationFiles < ActiveRecord::Migration
  def self.up
    create_table "citation_files", :force => true do |t|
    t.string   "file_name",                    :null => false
    t.integer  "file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "original_name", :limit => nil, :null => false
  end
  end

  def self.down
    drop_table :citations_citation_files
  end
end
