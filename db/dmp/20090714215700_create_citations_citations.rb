class CreateCitationsCitations < ActiveRecord::Migration
  def self.up
     create_table "citations", :force => true do |t|
    t.string   "type"
    t.string   "title"
    t.string   "short_title"
    t.string   "translated_title"
    t.string   "short_author"
    t.string   "original_publication"
    t.string   "journal"
    t.string   "volume"
    t.string   "number"
    t.string   "issue"
    t.string   "pages"
    t.integer  "address_id"
    t.string   "institution"
    t.string   "organization"
    t.string   "edition"
    t.string   "key"
    t.string   "keywords"
    t.string   "abstract"
    t.string   "editor"
    t.string   "language"
    t.string   "series_editor"
    t.string   "series_title"
    t.string   "abbr_series_title"
    t.string   "series_volume"
    t.string   "series_issue"
    t.string   "reprint_edition"
    t.string   "call_number"
    t.string   "accession_number"
    t.string   "issn_or_isbn"
    t.string   "isbn_or_issn"
    t.string   "bhp"
    t.string   "url"
    t.string   "doi"
    t.string   "notes"
    t.string   "access_date"
    t.string   "research_notes"
    t.string   "caption"
    t.string   "type_of_work"
    t.string   "translator"
    t.integer  "citation_files_id"
    t.string   "recpermissions_id"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
    t.integer  "publication_id"
    t.string   "city",                 :limit => nil
    t.integer  "publisher_id"
    t.integer  "image_id"
    t.integer  "number_of_volumes"
    t.string   "chapter",              :limit => nil
    t.string   "book_title",           :limit => nil
    t.integer  "title_id"
    t.integer  "year"
    t.integer  "month"
    t.integer  "user_id"
  end
  end

  def self.down
    drop_table :citations_citations
  end
end
