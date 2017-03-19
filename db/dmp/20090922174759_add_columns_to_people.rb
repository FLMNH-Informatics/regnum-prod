class AddColumnsToPeople < ActiveRecord::Migration
  def self.up
     add_column :people, :country, :string
     add_column :people, :fax, :integer
     add_column :people, :institution, :string
  end

  def self.down
  remove_column :people, :country
    remove_column :people, :fax
    remove_column :people, :institution
  end
end
