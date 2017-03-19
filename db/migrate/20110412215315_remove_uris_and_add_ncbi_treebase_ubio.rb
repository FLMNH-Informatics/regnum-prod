class RemoveUrisAndAddNcbiTreebaseUbio < ActiveRecord::Migration
 def self.up
=begin
     remove_column  :specimens, :uri
     remove_column  :apomorphies, :uri
     change_column :species, :ubio_id, :string
     add_column :specimens, :treebase_id, :string
     add_column :specimens, :ubio_id, :string
     add_column :specimens, :ncbi_id, :string
     add_column :apomorphies, :treebase_id, :string
     add_column :apomorphies, :ubio_id, :string
     add_column :apomorphies, :ncbi_id, :string
=end
 end

  def self.down
#    remove_column :users, :avatar_file_name
#    remove_column :users, :avatar_content_type
#    remove_column :users, :avatar_file_size
#    remove_column :users, :avatar_updated_at
  end
end
