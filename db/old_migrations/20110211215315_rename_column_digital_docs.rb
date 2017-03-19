class RenameColumnDigitalDocs < ActiveRecord::Migration
 def self.up
    rename_column :digital_docs, :filename, :attachment_file_name
    rename_column :digital_docs, :content_type, :attachment_content_type
    rename_column :digital_docs, :size, :attachment_file_size
    rename_column :digital_docs, :updated_at,   :attachment_updated_at
  end

  def self.down
#    remove_column :users, :avatar_file_name
#    remove_column :users, :avatar_content_type
#    remove_column :users, :avatar_file_size
#    remove_column :users, :avatar_updated_at
  end
end
