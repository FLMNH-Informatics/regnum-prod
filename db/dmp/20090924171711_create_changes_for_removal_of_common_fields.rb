class CreateChangesForRemovalOfCommonFields < ActiveRecord::Migration
  def self.up
    #unused columns from citations
    remove_column :citation, :short_title
    remove_column :citation, :translated_title
    remove_column :citation, :short_author
    remove_column :citation, :original_publication
    remove_column :citation, :address_id
    remove_column :citation, :institution
    remove_column :citation, :organization
    remove_column :citation, :language
    remove_column :citation, :abbr_series_title
    remove_column :citation, :series_issue
    remove_column :citation, :reprint_edition
    remove_column :citation, :call_number
    remove_column :citation, :accession_number
    remove_column :citation, :issn_or_isbn
    remove_column :citation, :bhp
    remove_column :citation, :access_date
    remove_column :citation, :research_notes
    remove_column :citation, :caption
    remove_column :citation, :type_of_work
    remove_column :citation, :translator
    remove_column :citation, :recpermissions_id
    remove_column :citation, :title_id
    remove_column :citation, :month

    #unused columns from publications
    remove_column :publications, :sherpa_id
    remove_column :publications, :source_id
    remove_column :publications, :authority_id
    remove_column :publications, :place

    #creating new table for storing the common attributes
    create_table :citations_attributes do |t|
      t.string :journal
      t.string :volume
      t.string :number
      t.string :issue
      t.string :pages
      t.string :edition
      t.string :key
      t.string :keywords
      t.string :abstract
      t.string :editor
      t.string :series_editor
      t.string :series_title
      t.string :series_volume
      t.string :isbn_or_issn
      t.string :url
      t.string :doi
      t.string :notes
      t.string :city
      t.integer :number_of_volumes
      t.string :chapter
      t.string :book_title
      t.integer :year
    end

    #adding foriegn keys to the above table
    add_column :citation, :citations_attributes_id, :integer
    add_column :publications, :citations_attributes_id, :integer
 
  end

  def self.down
  end
end
