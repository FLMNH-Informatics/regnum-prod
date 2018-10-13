class AddQualifyingClauseToSubmission < ActiveRecord::Migration
  def change
    add_column :submissions, :qualifying_clause, :text
  end
end
