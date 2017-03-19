class MoreChangesForSubmissions < ActiveRecord::Migration
  def self.up
    add_column :submissions, :name_string, :string
    add_column :submissions, :abbreviation, :string
  end

  def self.down
    remove_column :submissions, :name_string
    remove_column :submissions, :abbreviation
  end
end
