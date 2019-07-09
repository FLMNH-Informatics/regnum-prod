class AddSubmissionDescriptionCitations < ActiveRecord::Migration[5.2]
  def up

    create_table :submission_description_citations, force: true, id: false do |t|
      t.references :submission, foreign_key: true, type: :integer
      t.references :citation, foreign_key: true
    end

    add_index :submission_description_citations,
              [:submission_id, :citation_id],
              unique: true,
              name: :index_submission_description_citation
  end

  def down
    remove_foreign_key :submission_description_citations, column: :submission_id
    remove_foreign_key :submission_description_citations, column: :citation_id

    drop_table :submission_description_citations
  end
end