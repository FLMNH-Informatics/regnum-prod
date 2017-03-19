class SubmissionsController < ApplicationController

  before_filter :requires_a_editor_or_admin

  def index
    @subs = submissions_for_editor(params)
    if request.xhr?
      render :partial => 'submissions/submissions_table' , :layout => false
    end
  end

  def show
    @sub = Submission.find(params[:id])
    @stats = StatusChange.where(:submission_id => params[:id]).order('changed_at DESC')

    #if request.xhr?
      render :show, :layout => false
    #end     
  end

  def destroy
    Submission.delete(params[:id])
    SubmissionCitationAttachment.delete_all(["submission_id = ?", params[:id]])
    #request.xhr? ? head :ok : redirect_to :action => :index
    @subs = submissions_for_editor(params)
    if request.xhr?
      render :partial => 'submissions/submissions_table' , :layout => false
    else
      redirect_to :action => :index
    end
  end
  

  def update

    sub = Submission.find(params[:id])
    sub.status_id = params[:status]
    sub.status_comments= params[:editor_comments]
    sub.save
    #send email
    #StatusMailer.status_change(current_user, sub).deliver
    if request.xhr?
      index
    else
      redirect_to :action => :index
    end
  end

  private
  #gets right set of subs depending of type of editor/admin
  def submissions_for_editor(params)
    params[:term] ||= ''
    params[:page] ||= '1'
    params[:order] ||= 'name'
    params[:dir] ||= 'up'
    dir = params[:dir] == 'up' ? 'ASC' : 'DESC'
    subs = if current_user.is_admin?
      Submission.where("name LIKE ?", "#{params[:term]}%") #admin sees all :)
    elsif current_user.is_reviewer?
      Submission.where("status_id > ? AND name LIKE ?", Status.find_by_status('unsubmitted').id, "#{params[:term]}%")
    elsif current_user.is_opt_out_reviewer?
      Submission.opt_out.where("status_id > ? AND name LIKE ?", Status.find_by_status('unsubmitted').id, "#{params[:term]}%")
    elsif current_user.is_opt_in_reviewer?
      Submission.opt_in.where("status_id > ? AND name LIKE ?", Status.find_by_status('unsubmitted').id, "#{params[:term]}%") 
    end .order("#{params[:order]} #{dir}").paginate(:page => params[:page], :per_page => 12)
    return subs
  end
end