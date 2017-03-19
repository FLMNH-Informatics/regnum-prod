class CreateCitationsBookSections < ActiveRecord::Migration
  def self.up
    create_table :citations_book_sections do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :citations_book_sections
  end
end
