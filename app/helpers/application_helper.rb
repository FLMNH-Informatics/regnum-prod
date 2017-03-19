# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  # cheap helper for producing JS files to controller/action route
  def javascript_files_to_use
    files = ['float_window.js', 'sortable_table.js', 'global.js', 'knockout.min.js', 'knockout.mapping.js']
    out = ''
    case controller.controller_name+'/'+action_name
      when 'my_submission/index'
        files.concat ['list_submissions.js', 'cladename_tools.js']
      when 'my_submission/new'
        files.concat ['new_submission.js']#['cladename_tools.js','create_cladename.js']
      when 'my_submission/show'
        files.concat ['my_submissions/create_cladename.js','cladename_tools.js','my_submissions/float_window_actions.js','character_window.js', 'my_submissions/ko.paging.extender.js']
      when 'search/index'
        files.concat ['search_phylocode.js']
      when 'submissions/index'
        files.concat ['editor_submissions.js']
      when 'submissions/show'
        #files.concat ['submissions_show.js']
      when 'admin/index'
        files.concat ['admin_index.js']
      when 'phenotypes/index'
        files.concat ['application.js', 'my_submissions/ko.paging.extender.js', 'prototype.js','scriptaculous.js','builder.js','effects.js','characters.js','controls.js', 'dragdrop.js','phenotypes/float_window_actions.js']
    end
    files.each{|f| out +=  javascript_include_tag(f)+"\r\n" }
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
    if hashobj['attachment_id'] != nil && hashobj['attachment_path'] 
      hashobj['attachment'] = raw("<a class=\"attachment-link\" title=\"click to view attachment\" href=\"#{hashobj['attachment_path']}\" >download &#8634;</a>")
      ['attachment_path','attachment_id'].each{|attr| hashobj.delete(attr)}     
    end
    return hashobj
  end
  
  def format_output(key,val)
    raw(case key
    when 'ubio_id'
      '<a class="outlink-link" href="http://www.ubio.org/browser/details.php?namebankID='+val+'">'+val+'</a>'
    when 'treebase_id'   
      '<a class="outlink-link" href="http://purl.org/phylo/treebase/phylows/tree/TB2:'+val+'">'+val+'</a>'
    when 'ncbi_id'
      '<a class="outlink-link" href="http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?id='+val+'">'+val+'</a>'
    when 'treebase_tree_id'
      '<a class="outlink-link" href="http://purl.org/phylo/treebase/phylows/tree/TB2:'+val+'">'+val+'</a>'
    else
      val
    end)
  end
end
