class CharactersController < ApplicationController
  include Restful::Responder

  before_filter :requires_authentication

  def index
#    respond_to do |format|
#      format.any(:xml, :json) {
#        @characters =
#          (@resource = Character).
#            offset(params[:start].to_i || 0).
#            limit( params[:limit].to_i || 50)
           params[:page] = 1 if params[:page].nil?
           if !params[:query].nil?
            @characters = Character.where("name ILIKE ?", params[:query]+'%').order("name").paginate(:page => params[:page] , :per_page => 10 )
           else
            @characters = Character.order("name").paginate(:page => params[:page] , :per_page => 10 )
           end

    
#        render request.format.to_sym => @characters
#      }
#      format.js { render js: 'index' }
#    end
#    respond_to do |format|
#      format.html
#      format.js
#      format.xml { render :xml => @characters }
#    end
  end

  def show
    
#    respond_to do |format|
#      format.any(:xml, :json) {
#        parse(params)
#        @character =
#          (@resource = Character.scoped).
#            apply_finder_options(prepare(params, for: :finder)).
#            find(params[:id])
#        render request.format.to_sym => @character
#      }
#      format.js { render js: 'show' }
#    end

  end

  def new
    respond_to do |format|
      format.js 
      format.html 
    end
  end

  def create_character
    params[:character][:creator_id]=124
    params[:character][:updator_id]=124
    Character.create!(params[:character])
    redirect_to '/characters'
  end

  def destroy_character
    #params[:id].collect!{|x| x = x.to_i}
    Character.destroy(params[:id])
    head :ok
  end

  def destroy_state
    #params[:id].collect!{|x| x = x.to_i}
    State.destroy(params[:id])
    head :ok
  end

  def destroy_phenotype
    #params[:id].collect!{|x| x = x.to_i}
    Phenotype.destroy(params[:id])
    head :ok
  end
end
