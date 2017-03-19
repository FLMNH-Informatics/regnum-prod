class AlterSubmissionTable < ActiveRecord::Migration
  def self.up
    add_column :submissions, :updated_by, :timestamp
    remove_column :submissions, :approved_by
    remove_column :submissions, :approved
    remove_column :submissions, :returned
    add_column :submissions, :status_id, :integer
  end

  def self.down
  end
end
