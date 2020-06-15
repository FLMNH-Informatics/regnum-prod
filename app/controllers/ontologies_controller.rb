class OntologiesController < ApplicationController

  #before_filter :requires_authentication, :except => [:get_concept, :auto_complete]

  def index
      #params[:path_from] = true #if request.fullpath.match(/\/remote/)
=begin
      ontologies = Remote::Bioportal::Ontology.offset(0).all_hash params
      @bioportal = ontologies[:ontologies].sort do |x,y|
        if x[:abbreviation].nil? && !y[:abbreviation].nil?
          1
        elsif !x[:abbreviation].nil? && y[:abbreviation].nil?
          -1
        else
           x[:abbreviation].to_s.downcase <=> y[:abbreviation].to_s.downcase
        end
      end
=end 
      if request.xhr? 
        #params[:page] = 1 if params[:page].nil?
        bioportal = BioportalOntology.order('abbreviation ASC')#@bioportal#.paginate(:page => params[:page], :per_page => 10)
        biojson = []
        bioportal.each do |bio|
          biojson << {:id => bio.id, :bioportal_id => bio.bioportal_id, :abbreviation => bio.abbreviation, :ontology => bio.ontology}
        end
        imported = [] 
        @current_user.ontologies.each{|c| imported << {:id => c.id, :bioportal_id => c.bioportal_id, :abbreviation => c.abbreviation, :ontology => c.attributes } }#.paginate(:page => params[:imported_page], :per_page => 10)
        jsonobj = {:biojson => biojson, :imported => imported}
        render :json => jsonobj
        #

        #@roots = Concept.select('ontology_concepts.id, ontology_concepts.ontology_id, ontology_terms.term as con_term').joins(:relationships => :relationship_term).joins(:term).group('ontology_concepts.id').having('sum(ontology_relationship_terms.super_sub)<1')
      else
        render :index
      end
     #@current_user.ontologies << Ontology.all
     #@current_user.ontologies.delete(Ontology.find([100,70]))
  end

  def auto_complete_terms
    @query = params[:term]
    ontology_ids = params[:ontology_id] ||
        #User.find(session[:user_id]).ontology_ids
        Ontology.select('ontologies.id').joins(:users).where(:users => {:id => session[:user_id]})
        #Ontology.select(:id).joins('INNER JOIN `ontologies_users` ON `ontologies`.id = `ontologies_users`.ontology_id').where('ontologies_users.user_id' => session[:user_id])
    @terms = Term.joins(:concept).where(:concept => {:ontology_id => ontology_ids}).where("term LIKE ? or term LIKE ?", @query+"%", "% "+@query+"%").order(:term)
    #render :partial => "auto_complete"
    @list = [];
    @terms.each{|term| 
       @list << {:label => term.term, :value => term.term}
    }
    render :json =>  @list.to_json
  end

  def get_concept
    #@concept = Concept.includes(:terms, :relationships => [:relationship_term, :to_concept => :term]).find(params[:conceptId])
    @concept = Concept.find(params[:conceptId])
    #test = @concept.relationships.with_terms.all
    render :partial => "concept"
  end

  def new
    respond_to do |format|
      format.js { render js: 'new' }
    end
  end

  def show
    respond_to do |format|
      format.js { render js: 'show' }
    end
  end

  def destroy

    x = params[:ontology_id]
    Concept.destroy_all(["ontology_id = ?",x.to_i])
    Ontology.destroy(x)
    head :ok
  end

  def destroy_all
    #ActiveRecord::Base.connection.execute('DELETE FROM `ontologies_users` WHERE `user_id` = ' + @current_user.id.to_s + ' AND `ontology_id` IN (' + params[:ontology_ids] + ')')
    params[:ontology_ids] = params[:ontology_ids].split(',') if params[:ontology_ids].is_a?(String)
    @current_user.ontologies.delete(Ontology.find(params[:ontology_ids]))
    #params[:ontology_ids].each do |x|
    #  #Concept.destroy_all(["ontology_id = ?",x.to_i])
    #  concept_ids = Ontology.find(x).concept_ids
    #  Term.delete_all(:concept_id => concept_ids)
    #  Relationship.delete_all(["from_concept_id IN (?) OR to_concept_id IN (?)", concept_ids, concept_ids])
    #  Concept.delete(concept_ids)
    #  Ontology.delete(x)
    #end
    #head :ok
    redirect_to :action => :index
    #index
    #render :index
  end

  def create

    params[:ontology_ids] = params[:ontology_ids].split(',') if params[:ontology_ids].is_a?(String)
    params[:ontology_ids].each do |x|
       ontology = Ontology.find_by_bioportal_id(x) #next unless Ontology.where(:bioportal_id => x).exists?
       unless ontology.nil?
           @current_user.ontologies << ontology unless @current_user.ontologies.exists?(ontology)
           next
       end

       doc = Nokogiri::XML(open("http://rest.bioontology.org/bioportal/virtual/ontology/#{x}?apikey=305277ee-63e7-4f8e-bcb3-b51160a4ebfd"))
       ontologyBean = doc.xpath('//success/data/ontologyBean')

       ontology = @current_user.ontologies.create!(:bioportal_id => x,
                        :abbreviation => ontologyBean.at_xpath('abbreviation').try(:text),
                        :label => ontologyBean.at_xpath('displayLabel').try(:text),
                        :description => ontologyBean.at_xpath('description').try(:text),
                        :date_created => ontologyBean.at_xpath('dateCreated').try(:text))
        bioportal_id_to_id = Hash.new # bioportal id to concept id, needed when creating relationships later
        concepts = Array.new # to be saved to db in batches (much faster)
        terms = Array.new # to be saved to db in batches (much faster)
        concept_id = 0 # concept counter to make temp ids
       if x != "1042"
          doc = Nokogiri::XML(open("http://rest.bioontology.org/bioportal/virtual/ontology/#{x}/all?apikey=305277ee-63e7-4f8e-bcb3-b51160a4ebfd"))
          # loop through xml classBeans, create concepts
          doc.xpath('//success/data/page/contents/classBeanResultList/classBean').each do |classBean|
             bioportal_id = classBean.at_xpath('id').try(:text)
             concepts << ontology.concepts.build(:uri => classBean.at_xpath('fullId').try(:text), #:label => classBean.at_xpath('label').try(:text),
                                      :bioportal_id => bioportal_id,
                                      :definition => classBean.at_xpath('definitions/string').try(:text))
             if pt=classBean.at_xpath('label').try(:text)
               terms << Term.new(:term => pt, :preferred => true, :concept_id => concept_id)
             end
             classBean.xpath('synonyms/string').each do |synonym|
               terms << Term.new(:term => synonym.text, :concept_id => concept_id) if synonym.text
             end
             concept_id += 1

             if concept_id >= 500
               saveConcepts(concepts, terms, bioportal_id_to_id)
               concept_id = 0
             end
          end

          saveConcepts(concepts, terms, bioportal_id_to_id)

          # stores relationships for each xml fromClassBean
          # to determine super_sub and discard "superclass" and "subclass" relationships
          # - to_concept_id => {:terms => [relationship_term.terms], :super_sub => (true | false | nil)}
          to_id_to_rel = Hash.new

          # stores relationship terms to avoid multiple db calls for every relationship, used for the whole ontology
          # - relationship_term.term+super_sub => relationship_term.id
          term_to_id = Hash.new

          # terms to be saved to db in batches (much faster)
          relationships = Array.new

          # loop through xml classBeans, create relationships
          doc.xpath('//success/data/page/contents/classBeanResultList/classBean').each do |fromClassBean|
            #fromConcept = Concept.find_by_bioportal_id(classBean.at_xpath('id').try(:text))
            from_id = bioportal_id_to_id[fromClassBean.at_xpath('id').try(:text)]
            next if from_id.nil?
            to_id_to_rel.clear
            fromClassBean.xpath('relations/entry').each do |relation|
              term_str = relation.at_xpath('string').try(:text)

              # determine super_sub
              term_str_down = term_str.downcase
              if term_str_down == 'superclass'
                term_str = term_str_down
                super_sub = true
              end
              if term_str_down == 'subclass'
                term_str = term_str_down
                super_sub = false
              end
              relation.xpath('list/classBean').each do |toClassBean|
                #toConcept = Concept.find_by_bioportal_id(classBean2.at_xpath('id').try(:text))
                to_id = bioportal_id_to_id[toClassBean.at_xpath('id').try(:text)]
                next if to_id.nil?

                # create/modify to_id_to_rel item
                rel = to_id_to_rel[to_id]
                to_id_to_rel[to_id] = rel = Hash.new if rel.nil?
                if super_sub.nil?
                  # neither 'superclass' nor 'subclass'
                  if rel[:terms].nil? or rel[:terms]==['superclass'] or rel[:terms]==['subclass']
                    rel[:terms] = [term_str]
                  else
                    rel[:terms] << term_str
                  end
                else
                  # is 'superclass' or 'subclass'
                  rel[:super_sub] = super_sub
                  rel[:terms] = [term_str] if rel[:terms].nil?
                end
              end
            end

            # create db relationships based on to_id_to_rel
            to_id_to_rel.each do |to_id, rel|
              rel[:terms].each do |term_str|
                term_id = term_to_id[term_str + rel[:super_sub].to_s]

                # create and save db relationship term if not encountered before
                if term_id.nil? and !term_str.nil?
                  ##DEPRECATED IN RAILS 4###
                  #term_id = RelationshipTerm.find_or_create_by_term_and_super_sub(term_str, rel[:super_sub]).id
                  ###REPLACE WITH
                  term_id = RelationshipTerm.find_or_create_by(:term => term_str, :super_sub => rel[:super_sub]).id
                  term_to_id[term_str + rel[:super_sub].to_s] = term_id
                end

                relationships << Relationship.new(:from_concept_id => from_id, :to_concept_id => to_id, :relationship_term_id => term_id)
              end
            end
            if relationships.length >= 2000
              Relationship.import relationships, :validate => false
              relationships.clear
            end
          end
          Relationship.import relationships, :validate => false
       else
          doc = Nokogiri::XML(open("http://www.obofoundry.org/ro/ro.owl"))
          doc.xpath('//rdf:RDF//owl:TransitiveProperty').each do |classBean|
            bioportal_id = classBean.at_xpath('oboInOwl:hasAlternativeId').try(:text)
            concepts << ontology.concepts.build(:uri => classBean.attributes["about"].value, #:label => classBean.at_xpath('label').try(:text),
                                     :bioportal_id => bioportal_id)
            if pt=classBean.at_xpath('rdfs:label').try(:text)
              terms << Term.new(:term => pt, :preferred => true, :concept_id => concept_id)
            end
            concept_id += 1
#               Concept.create!({:uri => c.attributes["about"].value,
#                                :label => c.xpath('rdfs:label').children.first.content,
#                                :bioportal_id => c.xpath('oboInOwl:hasAlternativeId').children.first.content,
#                                :ontology_id => x.to_i })
#          end
#          doc = Nokogiri::XML(open("http://www.berkeleybop.org/ontologies/obo-all/ro_proposed/ro_proposed.owl"))
#          doc.xpath('//rdf:RDF//owl:ObjectProperty').each do |ch|
#               if ch.xpath('rdfs:label').length > 0
##                debugger if ch.xpath('rdfs:label').children.first.nil? || ch.xpath('oboInOwl:hasAlternativeId').children.first.nil?
#                Concept.create!({:uri => ch.attributes["about"].value,
#                                 :label => ch.xpath('rdfs:label').children.first.content,
#                                 :bioportal_id => (ch.xpath('oboInOwl:hasAlternativeId').children.first.nil? ? "" : ch.xpath('oboInOwl:hasAlternativeId').children.first.content),
#                                 :ontology_id => x.to_i })
#               end
          end
          saveConcepts(concepts, terms, bioportal_id_to_id)
       end
    end

    # TODO: need to not just throw validation errors to the application controller
    if request.xhr?
      render :json => {:saved => true}
    else
      redirect_to :action => :index
    end
    #index
    #redirect_to :action => :index
  end

  def saveConcepts(concepts, terms, bioportal_id_to_id)
    Concept.import concepts, :validate => false

    # find the id of the first concept saved to db
    base_id = ActiveRecord::Base.connection.execute("SELECT LAST_INSERT_ID();").extend(Enumerable).to_a.first.first.to_i

    # update foreign keys (concept_ids) in terms
    terms.each do |term|
      term.concept_id += base_id
    end
    Term.import terms, :validate => false

    # add values to bioportal_id_to_id
    concept_id = 0
    concepts.each do |concept|
      bioportal_id_to_id[concept.bioportal_id] = concept_id + base_id
      concept_id += 1
    end

    concepts.clear
    terms.clear
  end
end