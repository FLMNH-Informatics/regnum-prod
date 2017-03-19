class AddAuthorsToCladename < ActiveRecord::Migration
  def self.up
    add_column :cladenames, :authors, :string
  end

  def self.down
    remove_column :cladenames, :authors
  end
end
