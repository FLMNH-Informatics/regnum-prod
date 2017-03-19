class AddGuidToSub < ActiveRecord::Migration
  def self.up
    add_column :submissions, :guid, :string
  end

  def self.down
    remove_column :submissions, :guid
  end
end
