class AlterTreebaseId < ActiveRecord::Migration
  def self.up
    change_column :species, :treebase_id, :string
    change_column :specimens, :treebase_id, :string
    change_column :apomorphies, :treebase_id, :string
  end

  def self.down
  end
end
