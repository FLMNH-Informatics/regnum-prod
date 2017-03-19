
class AlterSubmissionsTable < ActiveRecord::Migration
  def self.up
    change_table :submissions do |t|
      t.remove :submission
      t.string :authors
      t.text :comments
      t.boolean :preexisting
      t.string :preexisting_code
      t.string :preexisting_authors
      t.string :type
      t.string :definition
      t.text :citations
      t.text :specifiers
    end
  end


  def self.down
  end
end
