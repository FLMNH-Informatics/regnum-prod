module Ontologies
  class TermsController < ApplicationController
    before_filter :requires_authentication

    def index
          start = (params[:page] || 0).to_i
          limit = (params[:limit] || 15).to_i
#          start_page = (start / limit) + 1
          doc =
            Nokogiri::XML(
              open(
                "http://rest.bioontology.org/bioportal/virtual/ontology/#{
                params[:ontology_id]
                }/all?&pagesize=#{
                limit
                }&pagenum=#{
                start
                }&apikey=b3b52a4b-f69b-4049-9336-5a7fe538e08d"
              )
            )
          @terms = {
            totalCount: doc.xpath('//success/data/page/numResultsTotal').first.content,
            total_pages: doc.xpath('//success/data/page/numPages').first.content,
            terms:
              doc.xpath('//success/data/page/contents/classBeanResultList/classBean').collect do |c|
                {
                 id:     c.xpath('id').first.try(:content),
                 fullId: c.xpath('fullId').first.try(:content),
                 label:  c.xpath('label').first.try(:content),
                 type:   c.xpath('type').first.try(:content),
                }
              end
          }

           params[:page] = 1 if params[:page].nil?
           @term_list = @terms[:terms]
#           .paginate(:page => params[:page] , :select=>"*", :per_page => 20 )
    end

    def show
      doc =
        Nokogiri::XML(
          open(
            "http://rest.bioontology.org/bioportal/virtual/ontology/#{params[:ontology_id]}?apikey=b3b52a4b-f69b-4049-9336-5a7fe538e08d"
          )
        )
      version_id = doc.xpath('//success/data/ontologyBean/id').first.content
      ontology_label = doc.xpath('//success/data/ontologyBean/displayLabel').first.content
      doc =
        Nokogiri::XML(
          open(
            "http://rest.bioontology.org/bioportal/concepts/#{version_id}?conceptid=#{params[:id]}&apikey=b3b52a4b-f69b-4049-9336-5a7fe538e08d"
          )
        )

      @out = {
        term: doc.xpath('//success/data/classBean/label').first.content,
        id: doc.xpath('//success/data/classBean/id').first.content,
        ontologyLabel: ontology_label,
        definition: (doc.xpath('//success/data/classBean/definitions/string').first.nil? ? "" : doc.xpath('//success/data/classBean/definitions/string').first.content)
      }
    end

    def search
     if !(params[:query] == "" || params[:query].nil?)

      doc =
        Nokogiri::XML(
          open(
            "http://rest.bioontology.org/bioportal/search/#{
            params[:query]
            }?apikey=b3b52a4b-f69b-4049-9336-5a7fe538e08d&ontologyids=#{
            params[:ontology_id]
            }"
          )
        )

      @terms = {
        totalCount: doc.xpath('//success/data/page/numResultsTotal').first.content,
        total_pages: doc.xpath('//success/data/page/numPages').first.content,
        terms:
          doc.xpath('//success/data/page/contents/searchResultList/searchBean').collect do |c|
            {
#             conceptIdShort:     c.xpath('conceptIdShort').first.try(:content),
#             ontologyId:         c.xpath('ontologyId').first.try(:content),
#             contents:           c.xpath('contents').first.try(:content)
             id:     c.xpath('conceptIdShort').first.try(:content),
             fullId:         c.xpath('conceptId').first.try(:content),
             label:           c.xpath('contents').first.try(:content)
            }
          end
      }
      params[:page] = 1 if params[:page].nil?
      @term_list = @terms[:terms]
     else
       redirect_to ontology_terms_path(params[:ontology_id]) 
     end
    end
  end
end