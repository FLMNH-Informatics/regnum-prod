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
end