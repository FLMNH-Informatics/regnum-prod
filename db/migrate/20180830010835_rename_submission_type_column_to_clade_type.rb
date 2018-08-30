class RenameSubmissionTypeColumnToCladeType < ActiveRecord::Migration
  def change
    rename_column :submissions, :type, :clade_type
  end
end
