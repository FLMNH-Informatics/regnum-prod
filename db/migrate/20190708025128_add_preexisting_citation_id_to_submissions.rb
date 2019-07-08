class AddPreexistingCitationIdToSubmissions < ActiveRecord::Migration[5.2]
  def change
    add_reference :submissions, :preexisting_citation, foreign_key: { to_table: :citations }, index: true
  end
end
