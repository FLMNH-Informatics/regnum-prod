class RemoveNcbiUbioTreebaseColumnsFromSpecimensApomorphies < ActiveRecord::Migration
  def self.up
    remove_column :specimens, :ncbi_id
    remove_column :specimens, :treebase_id
    remove_column :apomorphies, :treebase_id
  end

  def self.down
  end
end
