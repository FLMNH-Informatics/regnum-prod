class CreateCitationsPublisherSources < ActiveRecord::Migration
  def self.up
    create_table "publisher_sources", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
  end
  end

  def self.down
    drop_table :citations_publisher_sources
  end
end
