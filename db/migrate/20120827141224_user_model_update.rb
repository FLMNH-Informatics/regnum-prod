class UserModelUpdate < ActiveRecord::Migration
  def self.up
    add_column :users, :password_hash, :string
    add_column :users, :password_salt, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    remove_column :users, :name
  end

  def self.down
  end
end
