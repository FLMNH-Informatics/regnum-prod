class DropColumnSpecifiersSubmissionAndRenameSpecifiersJson < ActiveRecord::Migration[5.0]
  def change
    rename_column :submissions, :specifiers, :specifiers_old
    rename_column :submissions, :specifiers_json, :specifiers
    remove_column :submissions, :specifiers_old
  end
end
