class AddGuidToSpecimenTable < ActiveRecord::Migration
  def self.up
    add_column :specimens, :guid, :string
  end

  def self.down
    remove_column :specimens, :guid
  end
end
