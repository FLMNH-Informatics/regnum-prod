class AddAdditionalReferencePhylogenyCitationsTable < ActiveRecord::Migration[5.2]
  def up
    create_table :submission_reference_phylogenies, force: true, id: false do |t|
      t.references :submission, foreign_key: true, type: :integer
      t.references :citation, foreign_key: true
    end

    add_index :submission_reference_phylogenies,
              [:submission_id, :citation_id],
              unique: true,
              name: :index_submission_reference_phylogenies
  end

  def down
    remove_foreign_key :submission_reference_phylogenies, column: :submission_id
    remove_foreign_key :submission_reference_phylogenies, column: :citation_id

    drop_table :submission_reference_phylogenies
  end
end
