require 'will_paginate/array'

class SubmissionsController < ApplicationController

  before_filter :requires_a_editor_or_admin

  def index
    @subs = submissions_for_editor(params)
    if request.xhr?
      render :partial => 'submissions/submissions_table', :layout => false
    end
  end

  def show
    @sub   = Submission.find(params[:id])
    @stats = StatusChange.where(:submission_id => params[:id]).order('changed_at DESC')
    if request.xhr?
      render :json => @sub
    end
    # redirect_to controller: :my_submission, action: :show
  end

  def crown_specifiers
    @subs = Submission.crown_specifiers
    render :json => @subs
  end

  def edit
    @sub   = Submission.find(params[:id])
    @stats = StatusChange.where(:submission_id => params[:id]).order('changed_at DESC')

    respond_to do |format|
      format.html { render 'cladename/new' }
      format.json { render :json => @sub }
    end
  end

  def destroy
    Submission.delete(params[:id])
    SubmissionCitationAttachment.delete_all(["submission_id = ?", params[:id]])
    #request.xhr? ? head :ok : redirect_to :action => :index
    @subs = submissions_for_editor(params)
    if request.xhr?
      render :partial => 'submissions/submissions_table', :layout => false
    else
      redirect_to :action => :index
    end
  end


  def update
    @sub = Submission.find(params[:id])
    if (@sub.status_id == params[:status].to_i)
      flash[:notice] = "You must change the status to leave an editor comment."
      redirect_to action: :show
      return
    end
    @sub.status_id       = params[:status]
    @sub.status_comments = params[:editor_comments]
    @sub.save
    flash[:notice] = "Submission #{@sub.name} updated."
    #send email
    #StatusMailer.status_change(current_user, sub).deliver
    if request.xhr?
      index
    else
      redirect_to action: :show
    end
  end

  def export_json
    send_data Submission.all.map { |sub|
      if (sub.clade_type == Submission::CrownBasedTotalClade)
        sub.specifiers = sub.specifiers.select { |spec| spec["specifier_type"] == "crown" }
      end
      sub
    }.to_json,
              :type        => 'application/json',
              :disposition => "attachment",
              :filename    => "regnum_submissions.json"
  end

  def export
    require 'csv'
    csv_string = CSV.generate do |csv|
      csv << ["registration number", "clade name"]
      Submission.all.each { |submission| csv << [submission.registration_number, submission.name] }
    end
    send_data(csv_string,
              :type        => 'text/csv; charset=utf-8; header=present',
              :disposition => "attachment",
              :filename    => "regnum_cladenames_with_registration_number.csv")
  end

  private

  #gets right set of subs depending of type of editor/admin
  def submissions_for_editor(params)
    params[:term]       ||= ''
    params[:page]       ||= '1'
    params[:order]      ||= 'name'
    params[:dir]        ||= 'up'
    params[:clade_type] ||= 'all'

    dir  = params[:dir] == 'up' ? 'ASC' : 'DESC'
    subs = if current_user.is_admin?
             Submission.where("name LIKE ?", "%#{params[:term]}%") #admin sees all :)
           elsif current_user.is_reviewer?
             Submission.where("status_id > ? AND name LIKE ?", Status.find_by_status('unsubmitted').id, "%#{params[:term]}%")
           elsif current_user.is_opt_out_reviewer?
             Submission.opt_out.where("status_id > ? AND name LIKE ?", Status.find_by_status('unsubmitted').id, "%#{params[:term]}%")
           elsif current_user.is_opt_in_reviewer?
             Submission.opt_in.where("status_id > ? AND name LIKE ?", Status.find_by_status('unsubmitted').id, "%#{params[:term]}%")
           end.order("#{params[:order]} #{dir}")

    if params[:order] == "submitted_at"
      subs = subs.sort do |a,b|
          dir == "ASC" ? a.submitted_at <=> b.submitted_at : b.submitted_at <=> a.submitted_at
      end
    end
    subs = subs.paginate(:page => params[:page], :per_page => 12)
    return params[:clade_type] == 'all' ? subs : subs.where("clade_type = ?", params[:clade_type])
  end
end