class AddUserIdAndUpdatorIdForPublications < ActiveRecord::Migration
  def self.up
     add_column :publications, :user_id, :integer
     add_column :publications, :updator_id, :integer
  end

  def self.down
    remove_column :publications, :user_id
     remove_column :publications, :updator_id
  end
end
