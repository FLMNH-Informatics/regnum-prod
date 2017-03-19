class AddFieldToSubmissionsTable < ActiveRecord::Migration
  def self.up
    add_column :submissions, :establish, :boolean
  end

  def self.down
  end
end
