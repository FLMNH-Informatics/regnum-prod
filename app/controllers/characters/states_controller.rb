module Characters
  class StatesController < ApplicationController
    include Restful::Responder
    before_filter :requires_authentication
    
    def index
#      respond_to do |format|
#        format.any(:xml, :json) {
          @states =
            (@resource = Character.find(params[:character_id]).states).
              offset(params[:start].to_i || 0).
              limit( params[:limit].to_i || 50)
           params[:page] = 1 if params[:page].nil?
           @char_state_list = @states.paginate(:page => params[:page] , :select=>"*", :per_page => 10 )
#          render request.format.to_sym => @states
#        }
#        format.js { render js: 'index' }
#      end
     pheno_entity = []
     @char_state_list.each do |state|
       state[:phenotype_type] = generate_string_from_differentiae state.phenotype.try(:id), "ontology_composition_id",state.phenotype.try(:entity_term).try(:label)
  #    state['type'] = ""
       pheno_entity << state
     end
     respond_to do |format|
      format.html
      format.js
      format.xml { render :xml => pheno_entity }
     end
    end

#    def show
#      respond_to do |format|
#        format.any(:xml, :json) {
#          parse(params)
#          @state =
#            (@resource = State.scoped).
#              apply_finder_options(prepare(params, for: :finder)).
#              find(params[:id])
#          render request.format.to_sym => @state
#        }
#        format.js { render js: 'show' }
#      end
#    end
#  end

  def new
    respond_to do |format|
      format.js 
      format.html 
    end
  end

  def create
    params[:state][:creator_id]=124
    params[:state][:updator_id]=124
    params[:state][:character_id]=params[:character_id]
    State.create!(params[:state])
    redirect_to "/characters"
  end

  def destroy_all
    params[:id].collect!{|x| x = x.to_i}
    State.destroy(params[:id])
    head :ok
  end

  private
    def generate_string_from_differentiae pheno_id, col,entity
      return "" if entity.nil?
      recs = Differentia.where("#{col} = ?",pheno_id)
      recs.inject(entity) do |mem,rec|
      mem = mem + "^#{rec.relation_term.try(:label)}(#{rec.ontology_term.try(:label)})"
    end
  end

end
end