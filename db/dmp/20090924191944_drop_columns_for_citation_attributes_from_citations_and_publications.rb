class DropColumnsForCitationAttributesFromCitationsAndPublications < ActiveRecord::Migration
  def self.up

      remove_column :citation, :journal
      remove_column :citation, :volume
      remove_column :citation, :number
      remove_column :citation, :issue
      remove_column :citation, :pages
      remove_column :citation, :edition
      remove_column :citation, :key
      remove_column :citation, :keywords
      remove_column :citation, :abstract
      remove_column :citation, :editor
      remove_column :citation, :series_editor
      remove_column :citation, :series_title
      remove_column :citation, :series_volume
      remove_column :citation, :isbn_or_issn
      remove_column :citation, :url
      remove_column :citation, :doi
      remove_column :citation, :notes
      remove_column :citation, :city
      remove_column :citation, :number_of_volumes
      remove_column :citation, :chapter
      remove_column :citation, :book_title
      remove_column :citation, :year

    rename_column :publications, :citations_attributes_id, :citations_attribute_id

    Citations::Publication.find(:all).each do |pub|
      pub.citations_attribute.isbn_or_issn = pub.issn_isbn
      pub.save!
    end
    remove_column :publications, :url
    remove_column :publications, :issn_isbn

  end

  def self.down
  end
end
