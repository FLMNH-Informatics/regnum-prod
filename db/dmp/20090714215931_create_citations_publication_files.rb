class CreateCitationsPublicationFiles < ActiveRecord::Migration
  def self.up
    create_table "publication_files", :force => true do |t|
    t.string   "file_name"
    t.integer  "size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "content_typ", :limit => nil
  end
  end

  def self.down
    drop_table :citations_publication_files
  end
end
