class CreateCitationsCitationTypes < ActiveRecord::Migration
  def self.up
   create_table "citation_types", :force => true do |t|
    t.string  "name"
    t.string  "description"
    t.integer "user_id"
  end
  end

  def self.down
    drop_table :citations_citation_types
  end
end
