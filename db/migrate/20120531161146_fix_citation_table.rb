class FixCitationTable < ActiveRecord::Migration
  def self.up
    add_column :citations, :publisher, :string
    add_column :citations, :journal, :string
    add_column :citations, :article_title, :string
    add_column :citations, :book_editors, :string
    add_column :citations, :series_editors, :string
    add_column :citations, :edition, :string
    add_column :citations, :volumes, :string
    add_column :citations, :city, :string
    add_column :citations, :volume, :string
    add_column :citations, :number, :string
    add_column :citations, :isbn, :string
    add_column :citations, :abstract, :string
    add_column :citations, :keywords, :string
    add_column :citations, :url, :string
    add_column :citations, :doi, :string
    add_column :citations, :cladename_id, :integer

    remove_column :citations, :publication_name
  end

  def self.down
  end
end
