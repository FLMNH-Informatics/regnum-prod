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
  
end