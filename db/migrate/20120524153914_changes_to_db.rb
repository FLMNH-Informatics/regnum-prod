class ChangesToDb < ActiveRecord::Migration
  def self.up
    add_column :cladenames, :citation_id, :integer

    add_column :submissions, :data, :text
    add_column :submissions, :submitted, :boolean, :default => false
    add_column :submissions, :editable, :boolean, :default => true

  end

  def self.down
  end
end
