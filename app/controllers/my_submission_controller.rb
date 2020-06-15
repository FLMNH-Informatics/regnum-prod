require 'htmlentities'

class MySubmissionController < ApplicationController

  before_filter :requires_logged_in
  before_filter lambda { check_requester(params[:submission_id]) unless params[:submission_id] == 'new' }, :only => [:save, :add_attachment]
  # need filter for remove attachement to check user cred

  #
  #
  ##
  def index
    params[:term]  ||= ''
    params[:page]  ||= '1'
    params[:order] ||= 'name'
    params[:dir]   ||= 'up'
    dir            = params[:dir] == 'up' ? 'ASC' : 'DESC'
    params[:clade_type] ||= 'all'

    stats          = current_user ? "status_id IN (4,3,2)" : "status_id = 4"

    @subs = (params[:clade_type] == 'all' ? Submission : Submission.where('clade_type = ?', params[:clade_type]))
                .where("submitted_by = ? AND name LIKE ?", current_user.id, "%#{params[:term]}%")
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
    @sub   = Submission.find(params[:id])
    if current_user.id != @sub.user.id
      redirect_to my_submission_path
      return
    end
    @stats = StatusChange.where(:submission_id => params[:id]).order('changed_at DESC')
    respond_to do |format|
      format.html { render 'cladename/new' }
      format.json { render :json => @sub }
    end
  end


  def new
    @deftypeid  = GenericName.new
    @clad       = @deftypeid
    params[:id] = nil
    respond_to do |format|
      format.html { render 'cladename/create_clade' } #:cladename}
    end
  end

  def create
    @submission = Submission.create( name: params[:name], establish: params[:'opt-out'], submitted_by: current_user.id )
    if request.xhr?
      render :json => { :submission_id => @submission.id }.to_json
    else
      redirect_to show_my_submission_path(@submission.id)
    end
  end

  def save
    @submission = Submission.find(params[:submission_id])

    if current_user.id == @submission.user.id || current_user.is_admin?
      @submission = Submission.handle_save(params)
    end

    if request.xhr?
      render :json => @submission
    else
      redirect_to show_my_submission_path(@submission.id)
    end
  end

  #
  #
  ##
  def delete
    sub = Submission.find(params[:id])
    if current_user.id != sub.user.id
      flash[:error] = "You do not own this submission."
      redirect_to :action => :index
      return
    else
      if !sub.status.approved? || !sub.status.rejected?
        sub.delete
        SubmissionCitationAttachment.delete_all(["submission_id = ?", params[:id]])
      end
    end

    if request.xhr?
      params[:term]  ||= ''
      params[:page]  ||= '1'
      params[:order] ||= 'name'
      params[:dir]   ||= 'up'
      dir            = params[:dir] == 'up' ? 'ASC' : 'DESC'
      stats          = current_user ? "status_id IN (4,3,2)" : "status_id = 4"
      @subs          = Submission.where(["submitted_by = ? AND name LIKE ?", current_user.id, params[:term] + '%'])
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
  def check_name
    if params[:current_id]
      render :json => Submission.includes(:user).where({ name: params[:name] }).where.not(id: params[:current_id]),
                      :include => { :user => { :only => [:first_name, :last_name, :email] } }
    else
      render :json => Submission.includes(:user).where({ name: params[:name] }),
                    :include => { :user => { :only => [:first_name, :last_name, :email] } }
    end
  end

  #
  #
  ##
  def add_attachment
    sub = Submission.find(params[:submission_id])
    if current_user.id != sub.user.id
      flash[:error] = "You do not own this submission."
      redirect_to :action => :index
      return
    end
    attach               = SubmissionCitationAttachment.new
    attach.file          = params[:file]
    attach.submission_id = params[:submission_id]
    attach.citation_type = params[:type]
    #index id for phylogeny attachments

    attach.index_id = (params.has_key?(:cid) ? params[:cid] : 0)
    attach.save

    render :json => { :path => attach.file.to_s, :id => attach.id }.to_json
  end

  #
  #
  ##
  def view_attachment
    attach = SubmissionCitationAttachment.find(params[:id])
    send_file(Rails.root.to_s + '/public' + attach.file.to_s)
  end

  #
  #
  ##
  def remove_attachment
    sub = Submission.find(params[:submission_id])
    if current_user.id != sub.user.id
      flash[:error] = "You do not own this submission."
      redirect_to :action => :index
      return
    end
    id = params[:id]
    begin
      SubmissionCitationAttachment.find(id).destroy
      head :ok
    rescue
      head 500
    end
  end


  private

  #
  #confirms submission being submitted belongs to the requester
  ##this is where admin gets the pass to update a record it did not create
  ## as opposed to just leaving comments like an editor/reviewer
  def check_requester(submission_id)
    if (!Submission.find(submission_id).submitted_by_user?(current_user.id) && !current_user.is_admin?)
      unauthorized_request
    end
  end
  #
  #
  #
end
