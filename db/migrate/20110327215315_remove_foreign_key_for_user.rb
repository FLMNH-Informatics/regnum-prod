class RemoveForeignKeyForUser < ActiveRecord::Migration
 def self.up
=begin
      execute <<-SQL
                    ALTER TABLE users drop FOREIGN KEY  people_fk_users_1

             SQL
=end
  end

  def self.down
#    remove_column :users, :avatar_file_name
#    remove_column :users, :avatar_content_type
#    remove_column :users, :avatar_file_size
#    remove_column :users, :avatar_updated_at
  end
end
