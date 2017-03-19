class UserModelCleanUp < ActiveRecord::Migration
  def self.up
    remove_column :users, :initials
    remove_column :users, :crypted_password
    remove_column :users, :password
    remove_column :users, :phone
    remove_column :users, :fax
    remove_column :users, :person_id
    remove_column :users, :login
    remove_column :users, :salt
  end

  def self.down
  end
end
