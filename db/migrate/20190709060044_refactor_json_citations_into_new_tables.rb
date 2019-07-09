class RefactorJsonCitationsIntoNewTables < ActiveRecord::Migration[5.2]
  def change
    book_type = CitationType.find_by_citation_type :book
    book_section = CitationType.find_by_citation_type :book_section
    journal = CitationType.find_by_citation_type :journal
    Submission.all.each do |sub|
      sub.create_definitional_citation_from_json(sub.citations[:definitional])
      sub.create_preexisting_citation_from_json(sub.citations[:preexisting])
      sub.create_primary_phylogeny_citation_from_json(sub.citations[:primary_phylogeny])
      sub.citations[:phylogeny].each do |cit|
        sub.create_reference_phylogeny_from_json(cit)
      end
      sub.citations[:description].each do |cit|
        sub.create_description_citation_from_json(cit)
      end
      sub.save
    end
  end
end
