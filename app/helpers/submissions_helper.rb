module SubmissionsHelper

  def name_string_formatted
    raw @sub.name_string.sub(@sub.name, "<em>#{@sub.name}</em>")
  end

  def abbreviation_formatted
    abv = @sub.abbreviation
    @sub.specifiers.each do |spec|
      sn = spec[:specifier_name]
      abv.sub!(sn, "<em>#{sn}</em>")
    end
    raw abv
  end

  def verbatim_definition
    definition = @sub.definition
    @sub.specifiers
        .map { |sv| sv[:specifier_name] }
        .each { |spec_name| definition.gsub!(/#{spec_name}/i, '<em>\0</em>') }
    raw definition
  end

  def crown_specifiers_select_tag
    select_tag("crown_specifier",
               options_from_collection_for_select(Submission.crown_specifiers, :name_id, :name),
               include_blank: true,
               data: { bind: "value: specifier_crown" })

  end

end