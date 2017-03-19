class RemoveUrisAndRemoveNcbiTreebaseUbioFromSpecimenAndApomorphy < ActiveRecord::Migration
 def self.up
#     remove_column  :cladenames, :uri
#     remove_column  :preexisting_names, :uri
#     remove_column :specimens, :treebase_id
=begin
     remove_column :specimens, :ubio_id
     remove_column :specimens, :ncbi_id
     remove_column :apomorphies, :treebase_id
     remove_column :apomorphies, :ubio_id
     remove_column :apomorphies, :ncbi_id

=end
  end

  def self.down
#    remove_column :users, :avatar_file_name
#    remove_column :users, :avatar_content_type
#    remove_column :users, :avatar_file_size
#    remove_column :users, :avatar_updated_at
  end
end
