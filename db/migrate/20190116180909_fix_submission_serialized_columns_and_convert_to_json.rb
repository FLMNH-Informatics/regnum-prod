class FixSubmissionSerializedColumnsAndConvertToJson < ActiveRecord::Migration[5.0]
  class TempSubmission < ApplicationRecord
    self.table_name = 'submissions'
    serialize :citations_old
    serialize :authors
  end

  def up
    #add new json columns
    add_column :submissions, :authors_json, :json
    add_column :submissions, :citations_json, :json
    #
    # #ETL data into json columns
    TempSubmission.all.each do |sub|
      sub.authors_json = sub.authors.to_json
      sub.citations_json = sub.citations.to_json
      sub.save!
    end
    #
    # # rename old columns and new columns
    rename_column :submissions, :authors, :authors_old
    rename_column :submissions, :citations, :citations_old

    rename_column :submissions, :authors_json, :authors
    rename_column :submissions, :citations_json, :citations

    remove_column :submissions, :citations_old
    remove_column :submissions, :authors_old
  end

  def down

  end
end
