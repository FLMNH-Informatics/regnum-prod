require 'cgi'

class SearchController < ApplicationController

  before_filter :requires_logged_in, :only => [:search_res]

  #new search - index delegates search functions.
  def index
    params[:term] ||= ''
    params[:page] ||= '1'
    params[:order] ||= 'name'
    params[:dir] ||= 'up'

    dir = params[:dir] == 'up' ? 'ASC' : 'DESC'
    stats = current_user ? "status_id IN (4,3,2)" : "status_id = 4"
    @sub = Submission.where(["name LIKE ? AND #{stats}", params[:term] + '%'])
             .order("#{params[:order]} #{dir}")
               .paginate(:page => params[:page], :per_page => 12)
    if request.xhr?
        render :partial => 'search_table', :layout => false
    else
        render 'index', :layout => (logged_in? ? 'application' : 'public')
    end
  end

  #for searching resources 
  def search_res
    partial =  'search/search_resource_table'
    case params[:resource]
      when 'ncbi'
        @results = ncbi_search(params[:search])
      when 'ubio'
        @results = ubio_search(params[:search])
        partial = 'search/search_ubio_table'
      when 'treebase'
        @results = treebase_search(params[:search])
      when 'treebase_tree'
        @results = treebase_tree_search(params[:search])
      else
        @results = 'NORESOURCE'
    end
    
    render :partial => partial
  end

  def show
    @sub = Submission.find(params[:id])
    if request.xhr?
      render :partial => 'shared/cladename_view', :layout => false
    else
      render  'show', :layout => true
    end
  end
#  def show
 #   redirect_to species_search_index_path
#  end

  private

  def ubio_search(term)
    key = "0e6f4af5959e3c6eb7fa7c0a1dfb578be821c736"
    uri = "http://www.ubio.org/webservices/service.php?function=namebank_search&searchName="
    term = term.strip

    uri << CGI::escape(term) + "&sci=1&vern=0&keyCode=" + key
    doc = Nokogiri::XML(open(uri))
    #render :partial => "shared/ubio_selection"
    out = []
    doc.search("/results/scientificNames/value").each do |name|
      out << {'value' => name.search('namebankID').inner_html, 
              'label' => Base64.decode64(name.search('fullNameString').inner_html),
              'basionymUnit' => Base64.decode64(name.search('basionymUnit').inner_html),
              'packageName' => name.search('packageName').inner_html,
              'rankName' => name.search('rankName').inner_html,
              }
    end   
    out
  end

  def ncbi_search(term)
    esearch_uri = "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=Taxonomy&tool=REGNUM&email=ugandharc18@gmail.com&field=SCIN&term="
    uri = esearch_uri + CGI::escape(term) + '*'
    doc = Nokogiri::XML(open(uri))
    uri_id = ""
    doc.search("//Id").each do |id|
      uri_id << id.inner_html + ","
    end
    uri_id = uri_id.chop
    esummary_uri = "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?db=Taxonomy&tool=REGNUM&email=ugandharc18@gmail.com&id="
    uri = esummary_uri + uri_id + "&retmode=xml"
    doc = Nokogiri::XML(open(uri))

    out = []
    doc.search("//DocSum").each do |name|
       out << { 'label' => name.search("Item[@Name='ScientificName']").inner_html, 'value' => name.search("Item[@Name='TaxId']").inner_html}
    end
    out
  end

  def treebase_search(term)
    uri = 'http://treebase.org/treebase-web/search/taxonSearch.html?query=dcterms.title.taxon='
    #uri = 'http://treebase.org/taxon/find?&query=tb.title.taxon='
    uri << CGI::escape(term) + '&format=rss1&recordSchema=otu'
    doc = Nokogiri::XML(open(uri))
    out = []
    doc.search("item").each do |name|
      out << {'value' => (name/"link").inner_html.gsub!(/([a-z:A-Z0-9.\/]*)TB2:/,''), 'label' => (name/"title").inner_html}
    end
    out
  end

  def treebase_tree_search(term)
    uri = 'http://treebase.org/treebase-web/search/treeSearch.html?query=tb.title.tree='
    #uri = 'http://purl.org/phylo/treebase/phylows/tree/find?query=dcterms.title='
    #uri = 'http://treebase.org/treebase-web/search/treeSearch.html?query=dcterms.title='
    uri << CGI::escape(term) + '&format=rss1&recordSchema=tree'

    doc = Nokogiri::XML(open(uri))
    out = []
    doc.search("item").each do |name|
      out << {'value' => (name/"link").inner_html.gsub!(/([a-z:A-Z0-9.\/]*)TB2:/,''), 'label' => (name/"title").inner_html}
    end
    out
  end

end
