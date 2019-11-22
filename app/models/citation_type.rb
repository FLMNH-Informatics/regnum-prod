class CitationType < ApplicationRecord
  def is_journal?
    citation_type == 'journal'
  end

  def is_book?
    citation_type == 'book'
  end

  def is_book_section?
    citation_type == 'book_section'
  end

  def self.book
    self.find_by_citation_type('book')
  end

  def self.book_section
    self.find_by_citation_type('book_section')
  end

  def self.journal
    self.find_by_citation_type('journal')
  end
end