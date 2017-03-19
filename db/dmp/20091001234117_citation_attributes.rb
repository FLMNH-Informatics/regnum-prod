class CitationAttributes < ActiveRecord::Migration
  def self.up
    create_table "citations_attributes", :force => true do |t|
    t.string  "journal"
    t.string  "volume"
    t.string  "number"
    t.string  "issue"
    t.string  "pages"
    t.string  "edition"
    t.string  "key"
    t.string  "keywords"
    t.string  "abstract"
    t.string  "editor"
    t.string  "series_editor"
    t.string  "series_title"
    t.string  "series_volume"
    t.string  "isbn_or_issn"
    t.string  "url"
    t.string  "doi"
    t.string  "notes"
    t.string  "city"
    t.integer "number_of_volumes"
    t.string  "chapter"
    t.string  "book_title"
  end
  end

  def self.down
    drop_table :citations_attributes
  end
end
