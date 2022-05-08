# Methods added to this helper will be available to all templates in the application.
require 'uri'
module ApplicationHelper

  GuideUrl = "https://github.com/FLMNH-Informatics/regnum-documentation/blob/main/Guides/requirements-for-phylogenetically-defined-names-guide.pdf"

  # cheap helper for producing JS files to controller/action route
  def javascript_files_to_use
    # files = ['float_window.js', 'sortable_table.js', 'global.js', 'knockout.min.js', 'knockout.mapping.js']
    files = ['float_window.js', 'global.js', 'knockout.min.js', 'knockout.mapping.js']
    out = ''
    case controller.controller_name+'/'+action_name
      when 'my_submission/index'
        files.concat ['submissions_index.js', 'search_submissions.js', 'cladename_tools.js', 'submissions_table_actions.js']
      when 'my_submission/new'
        files.concat [ 'submission_model.js', 'new_submission.js']#['cladename_tools.js','create_cladename.js']
      when 'my_submission/show'
        files.concat [
         'submission_model.js',
         'my_submissions/create_cladename.js',
         'cladename_tools.js',
         'my_submissions/float_window_actions.js',
         'character_window.js',
         'my_submissions/ko.paging.extender.js' ]
      when 'search/index'
        files.concat ['search_phylocode.js']
      when 'submissions/index'
        files.concat [ 'submissions_index.js', 'search_submissions.js', 'submissions_table_actions.js']
      when 'submissions/show'
        files.concat ['submissions_show.js']
      when 'submissions/edit'
        files.concat [
           'submission_model.js',
           'my_submissions/create_cladename.js',
           'cladename_tools.js',
           'my_submissions/float_window_actions.js',
           'character_window.js',
           'my_submissions/ko.paging.extender.js' ]
      when 'admin/index'
        files.concat ['admin_index.js']
      when 'phenotypes/index'
        files.concat ['application.js', 'my_submissions/ko.paging.extender.js', 'prototype.js','scriptaculous.js','builder.js','effects.js','characters.js','controls.js', 'dragdrop.js','phenotypes/float_window_actions.js']
    end
    files.each{ |f| out +=  javascript_include_tag(f + "?#{Time.now.to_i}")+"\r\n" }
    raw(out)
  end
  
  #assumes params[:order] and params[:dir] exist in search
  def table_sort_header (name , view='')
    params[:page] ||= 1
    params[:term] ||= ''
    header = '&nbsp;'+ (view == '' ? name.humanize : view.humanize)
    path = '/'+ controller_name + "?term=#{params[:term]}&page=#{params[:page]}&order=#{name}&dir=#{dir_set(name)}"
    out = raw("<a href=\"#{path}\" title=\"click to sort\" class=\"table-header-link\">#{search_table_header_dir(name)}#{header}</a>")   
  end

  def search_table_header_dir(model_attr)
    params[:order] ||= 'name'
    params[:dir]  ||= 'up' 
    params[:order] == model_attr ? (params[:dir] == 'up' ? raw('<span class="bold">&#8593;</span>') : raw('<span class="bold">&#8595;</span>'))  : ''   
  end

  def dir_set(model_attr)
    params[:order] ||= 'name'
    params[:dir]  ||= 'up' 
    model_attr == params[:order] ? (params[:dir] == 'up' ? 'down' : 'up') : 'up'
  end
  
  def attachment_prepare hashobj
    if !hashobj.nil?
      if hashobj['attachment_id'] != nil && hashobj['attachment_path']
        hashobj['attachment'] = raw("<a class=\"attachment-link\" title=\"click to view attachment\" href=\"#{hashobj['attachment_path']}\" >download &#8634;</a>")
        ['attachment_path','attachment_id'].each{|attr| hashobj.delete(attr)}
      end
      return hashobj
    end
  end

  def format_output(key, val)
    raw(case key
          when 'citation_type'
            val.humanize
          when 'ubio_id'
            '<a class="outlink-link" href="http://www.ubio.org/browser/details.php?namebankID=' + val + '">' + val + '</a>'
          when 'treebase_id'
            '<a class="outlink-link" href="http://purl.org/phylo/treebase/phylows/tree/TB2:' + val + '">' + val + '</a>'
          when 'ncbi_id'
            '<a class="outlink-link" href="http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?id=' + val + '">' + val + '</a>'
          when 'treebase_tree_id'
            '<a class="outlink-link" href="http://purl.org/phylo/treebase/phylows/tree/TB2:' + val + '">' + val + '</a>'
          when 'url'
            url = val.start_with?("http") ? val : "https://" + val
            if url =~ URI::regexp
              out = '<a class="outlink-link" href="' + url + '">' + val + '</a>'
            else
              out = val
            end
            out
          when 'authors'
            display_authors val
          when 'editors'
            display_authors val
          when 'series_editors'
            display_authors val
          when 'collectors'
            display_authors val
          when 'specifier_name'
            '<i>' + val + '</i>'
          when 'definition_type'
            obj = Submission::CladeTypes.select{|ct| ct[:key] == val}
            if (obj.nil?)
              return ""
            end
            obj[:name]
          else
            val
        end)
  end

  def display_citation citation
    if has_authors? citation[:authors]
      return display_citation_with_authors citation
    end

    display_citation_with_editors citation
  end

  def display_citation_with_editors citation
    editors = editor_string citation[:editors]
    pages = get_citation_pages citation
    "#{editors}. (#{citation[:year]}) #{citation[:title]}. #{citation[:publisher]}, #{citation[:city]}. #{pages}"
  end

  def display_citation_with_authors citation
    authors = author_string citation[:authors]
    if has_authors? citation[:editors]
      editors = author_string citation[:editors]
    else
      editors = ""
    end
    pages = get_citation_pages citation
    "#{authors}. (#{citation[:year]}) #{citation[:title]}. #{editors} #{citation[:publisher]}, #{citation[:city]}. #{pages}"
  end

  def get_citation_pages citation
    pages = citation[:pages]
    if pages.nil? || pages.empty?
      return ""
    end

    if pages.include? "-"
      return "(pp. #{pages})"
    end

    "(p. #{pages})"
  end

  def author_string editors_array
    count = editors_array.count
    out = ""

    editors = editors_array.each_with_index.map do |auth, i|
      last_name = auth[:last_name]
      middle_name = auth[:middle_name]
      first_name = auth[:first_name]
      if i == 0
        "#{last_name}, #{citation_first_name(first_name)}#{citation_middle_name(middle_name)}"
      else
        "#{citation_first_name(first_name)}#{citation_middle_name(middle_name)} #{last_name}"
      end
    end

    last_index = count - 1

    if last_index == 0
      return editors.first
    end

    editors.each_with_index do |ed, i|
      if i == last_index
        out += "and #{ed}"
      else
        out += "#{ed}, "
      end
    end
    out
  end

  def editor_string editors_array
    count = editors_array.count
    if (count == 1)
      suffix = "(ed.)"
    else
      suffix = "(eds.)"
    end
    out = ""
    editors = editors_array.each_with_index.map do |auth, i|
      last_name = auth[:last_name]
      middle_name = auth[:middle_name]
      first_name = auth[:first_name]
      if i == 0
        "#{last_name}, #{citation_first_name(first_name)}#{citation_middle_name(middle_name)}"
      else
        "#{citation_first_name(first_name)}#{citation_middle_name(middle_name)} #{last_name}"
      end
    end
    last_index = count - 1
    editors.each_with_index do |ed, i|
      if i == last_index
        out += "and #{ed}"
      else
        out += "#{ed}, "
      end
    end
    "#{out} #{suffix}"
  end

  def citation_middle_name middle_name
    if middle_name.empty?
      return ""
    end
    return middle_name.slice(0) + "."
  end

  def citation_first_name first_name
    if first_name.empty?
      return ""
    end
    return first_name.slice(0) + "."
  end

  def has_authors? authors_array
    if authors_array.count == 0
      return false
    end

    if authors_array.count == 1
      author = authors_array.first
      if author[:first_name].empty? && author[:last_name].empty?
        return false
      end
    end

    true
  end

  def display_authors authors_array
    return "" if !has_authors? authors_array

    authors = authors_array.map do |auth|
      "#{auth[:last_name]}. #{auth[:first_name]} #{auth[:middle_name]}".strip
    end

    out = "<ul>"
    authors.each do |auth|
      out += "<li>#{auth}</li>"
    end
    out += "</ul>"
    raw out
  end
end
