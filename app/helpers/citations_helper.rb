module CitationsHelper

  def citation_title(citation)
    if citation.has_key? 'title'
      citation['title']
    else
      citation['article_title']
    end
  end

  def citation_blank?(citation)
    props = %W(authors title publisher journal book_editors series_editors figure year edition volumes city volume number pages keywords abstract isbn url doi treebase_tree_id)
  end

  def output_citation(reference_phylogeny)
    type = reference_phylogeny['citation_type']
    is_journal = type == "journal"
    out = ""
    unless !reference_phylogeny.has_key? 'figure' || reference_phylogeny['figure'].blank?
      out += "Figure number #{reference_phylogeny['figure']} in "
    end
    properties = is_journal ?
                     ['authors','year','journal','volumes','volume','pages'] :
                     ['authors','year','title','volumes','volume','pages']
    if is_journal
      properties = ['authors','year', 'title', 'journal','volumes','volume','pages', 'doi', 'url']
    else
      properties = ['authors','year','title','editor','publisher', 'volumes','volume','pages']
    end
    properties.each do |prop|
      if prop == 'year' && reference_phylogeny.has_key?(prop) && reference_phylogeny[prop].blank?
        out += "(n.d.)"
      end
      unless reference_phylogeny[prop].blank?
        val = format_output(prop, reference_phylogeny[prop])
        out +=  case prop
                when 'year'     then  "(#{val})"
                when 'title'    then  is_journal ? "#{val}." : "<em>#{val}</em>."
                when 'journal'  then  "<em>#{val}</em>,"
                when 'editor'   then  "#{val} (Ed.)"
                when 'volumes'  then  is_journal ? "<em>#{val}</em>," : "(Vols. #{val})."
                when 'volume'   then  is_journal ? "<em>#{val}</em>," : "(Vol. #{val})."
                when 'pages'    then  is_journal ? "#{val}." : "(pp. #{val})"
                when 'url'      then  "Retrieved from <a href=\"#{val}\">#{val}</a>"
                when 'doi'      then  "Retrieved from <a href=\"https://doi.org/#{val}\">https://doi.org/#{val}</a>"
                else                  "#{val}"
                end
        out += " "
      end
    end
    raw out
  end

end