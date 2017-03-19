class AddUserOntologies < ActiveRecord::Migration
  def self.up
  	create_table "ontologies_users", :id => false, :force => true do |t|
      t.integer "ontology_id"
      t.integer "user_id"
    end
  end

  def self.down
  end
end
