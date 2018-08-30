class ChangeSubmissionsTableMakeAuthorsText < ActiveRecord::Migration
  def change
    change_column :submissions, :authors, :text
  end
end
