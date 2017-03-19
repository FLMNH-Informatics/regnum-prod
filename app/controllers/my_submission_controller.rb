require 'htmlentities'

class MySubmissionController < ApplicationController

  before_filter :requires_logged_in
  before_filter lambda{ check_requester(params[:submission_id]) unless params[:submission_id] == 'new'} , :only => [:save, :add_attachment]
  # need filter for remove attachement to check user cred

  def new
    @deftypeid = GenericName.new
    @clad =  @deftypeid
    params[:id] = nil
    respond_to do |format|
      format.html { render 'cladename/create_clade' } #:cladename}
    end
  end
  #
  #
  ##
  def save
    id = params.delete(:submission_id) || 'new'
    if id == 'new'
      sub = Submission.new
      sub.name = params[:name]
      sub.establish = (params[:'opt-out'] == 'on' ? false : true)
      sub.submitted_by = current_user.id
      sub.save!
      if request.xhr?
        render :json => {:submission_id => sub.id}.to_json
      else
        redirect_to show_my_submission_path(sub.id)
      end
    else
      sub = Submission.find(id)
      sub.citations = params[:citations] if params.has_key?(:citations)
      sub.specifiers = params[:specifiers] if params.has_key?(:specifiers)
     
      sub.preexisting = params[:preexisting] == 'null' ? false : params[:preexisting]
      sub.comments = params[:comments]
      sub.preexisting_authors = params[:preexisting_authors]
      sub.preexisting_code = params[:preexisting_code]
      sub.type = params[:type]
      sub.definition = params[:definition]
      sub.name = params[:name]
      sub.authors = params[:authors]
      sub.name_string = params[:name_string]
      sub.abbreviation = HTMLEntities.new.decode(params[:abbreviation])
      sub.status_id = Status.find_by_status('submitted').id if params[:subaction] == 'submit'
      #sub.submitted_by = current_user.id
      sub.save!

      render :json => {:submission_id => sub.id}.to_json
    end

  end
  #
  #
  ##
  def delete
    sub = Submission.find(params[:id])
    if !sub.status.approved? || !sub.status.rejected?
      sub.delete
      SubmissionCitationAttachment.delete_all(["submission_id = ?", params[:id]])
    end
    if request.xhr?
      params[:term] ||= ''
      params[:page] ||= '1'
      params[:order] ||= 'name'
      params[:dir] ||= 'up'
      dir = params[:dir] == 'up' ? 'ASC' : 'DESC'
      stats = current_user ? "status_id IN (4,3,2)" : "status_id = 4"
      @subs = Submission.where(["submitted_by = ? AND name LIKE ?",  current_user.id, params[:term]+ '%'])
             .order("#{params[:order]} #{dir}")
               .paginate(:page => params[:page], :per_page => 12)
      render :partial => 'my_submission/my_submissions_table', :layout => false
    else
      redirect_to :action => :index
    end
  end
  #
  #
  ##
  def add_attachment
    attach = SubmissionCitationAttachment.new
    attach.file = params[:file]
    attach.submission_id = params[:submission_id]
    attach.citation_type = params[:type]
    #index id for phylogeny attachments

    attach.index_id = (params.has_key?(:cid) ? params[:cid] : 0)
    attach.save

    render :json => {:path => attach.file.to_s, :id => attach.id }.to_json
  end
  #
  #
  ##
  def view_attachment
    attach = SubmissionCitationAttachment.find(params[:id])
    send_file(Rails.root.to_s + '/public'+ attach.file.to_s)
  end
  #
  #
  ##
  def remove_attachment
    id = params[:id]
    begin
      SubmissionCitationAttachment.find(id).destroy
      head :ok
    rescue
      head 500
    end
  end
  #
  #
  ##
  def index
    params[:term] ||= ''
    params[:page] ||= '1'
    params[:order] ||= 'name'
    params[:dir] ||= 'up'
    dir = params[:dir] == 'up' ? 'ASC' : 'DESC'
    stats = current_user ? "status_id IN (4,3,2)" : "status_id = 4"
    @subs = Submission.where(["submitted_by = ? AND name LIKE ?",  current_user.id, params[:term]+ '%'])
             .order("#{params[:order]} #{dir}")
               .paginate(:page => params[:page], :per_page => 12)
    if request.xhr?
        render :partial => 'my_submissions_table', :layout => false
    else
        render 'index'
    end
  end
  #
  #
  ##
  def show
     #redirect_to create_submission
    @sub = Submission.find(params[:id])
    @stats = StatusChange.where(:submission_id => params[:id]).order('changed_at DESC')
    respond_to do |format|
      format.html {render 'cladename/new'}
      format.json {render :json => @sub }
    end
  end
  
  private
  #
  #confirms submission being submitted belongs to the requester
  ##this is where admin gets the pass to update a record it did not create
  ## as opposed to just leaving comments like an editor/reviewer
  def check_requester(submission_id)
    if(!Submission.find(submission_id).submitted_by_user?(current_user.id) && !current_user.is_admin?)
       unauthorized_request
    end
  end
  #
  #
  #
end
