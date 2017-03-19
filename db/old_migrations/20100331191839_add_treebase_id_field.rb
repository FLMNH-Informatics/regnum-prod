class AddTreebaseIdField < ActiveRecord::Migration
  def self.up
    add_column :species, :treebase_id, :integer
    add_column :specimens, :treebase_id, :integer
    add_column :apomorphies, :treebase_id, :integer
  end

  def self.down
  end
end
