class ChangeDefinitionToText < ActiveRecord::Migration
  def self.up
  	change_column :submissions, :definition, :text
  end

  def self.down
  end
end
