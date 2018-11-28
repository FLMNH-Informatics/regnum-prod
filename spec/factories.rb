FactoryGirl.define do
	factory :submission do
	  name "Campanulaceae"
		submitted_by  2
		establish  true
		status_id 1
		authors "Nico Cellinese, Some other people"
		comments "small flowering plants"
		preexisting true
		preexisting_code  "ICBN"
		preexisting_authors  "Some other"
		type  "node_based_crown_clade_branch-modified"
    definition  "some plant on or near the greek isles that nico likes to study"
    citations    [{ preexisting: [{ citation_type: 'journal'}], description:  [{}], phylogeny: [{}], :'primary-phylogeny' => [{}] }].to_yaml
    specifiers   [{ specifier_type: 'specimen', specifier_kind: 'internal_extant', specifier_name: 'intextspec' }].to_yaml
    name_string  "campanulaceae cellinese, 2001 (vol. 1)"
    abbreviation   "∇ some specifer ~ and another"
  end
end