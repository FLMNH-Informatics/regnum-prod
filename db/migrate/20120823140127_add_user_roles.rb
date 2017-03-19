class AddUserRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.integer :id
      t.string  :name
      t.integer :role_id
    end

    execute %{
      INSERT INTO roles (name,role_id) VALUES ('guest',1),('user',2),('reviewer',3),('admin',4)
    }
    rename_column :users, :role, :role_id
  end

  def self.down
  end
end
