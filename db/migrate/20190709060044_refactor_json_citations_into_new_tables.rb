class RefactorJsonCitationsIntoNewTables < ActiveRecord::Migration[5.2]
  def up
    Submission.all.each do |sub|
      sub.create_definitional_citation_from_json(sub.citations["definitional"], sub.user)
      sub.create_preexisting_citation_from_json(sub.citations["preexisting"], sub.user)
      sub.create_primary_phylogeny_citation_from_json(sub.citations["primary_phylogeny"], sub.user)
      sub.citations["phylogeny"].each do |cit|
        sub.create_reference_phylogeny_from_json(cit, sub.user)
      end unless sub.citations["phylogeny"].nil?
      sub.citations["description"].each do |cit|
        sub.create_description_citation_from_json(cit, sub.user)
      end unless sub.citations["description"].nil?
      sub.save!
    end
  end

  def down
    Citation.destroy_all
  end
end
