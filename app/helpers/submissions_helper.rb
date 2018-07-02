module SubmissionsHelper

    def name_string_formatted
      raw @sub.name_string.sub(@sub.name, "<em>#{@sub.name}</em>")
    end

  def abbreviation_formatted
    abv = @sub.abbreviation
    @sub.specifiers.values.each{|spec|
      sn = spec[:specifier_name]
      abv.sub!(sn, "<em>#{sn}</em>")
    }
    raw abv
  end

  def verbatim_definition
    definition = @sub.definition
    @sub.specifiers
        .values
        .map{|sv| sv[:specifier_name] }
        .each{ |spec_name| definition.gsub!( /#{spec_name}/i, '<em>\0</em>') }
    raw definition
  end
  
end