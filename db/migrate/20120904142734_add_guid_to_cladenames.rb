class AddGuidToCladenames < ActiveRecord::Migration
  def self.up
    add_column :cladenames, :guid, :string
  end

  def self.down
    remove_column :cladenames, :guid
  end
end
