class DropFirstNameLastNameFromUsersTable < ActiveRecord::Migration
  def self.up
    remove_column :users, :first_name
    remove_column :users, :last_name
  end

  def self.down
  end
end
