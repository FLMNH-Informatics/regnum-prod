class AddDefinitionalCitationIdToSubmissions < ActiveRecord::Migration[5.2]
  def change
    add_reference :submissions, :definitional_citation, foreign_key: { to_table: :citations }, index: true
  end
end
