class AdminController < ApplicationController
  #admin controlller 
  before_filter :requires_admin

  def index
    

    params[:term] ||= ''
    params[:page] ||= '1'
    params[:order] ||= 'last_name'
    params[:dir] ||= 'up'

    dir = params[:dir] == 'up' ? 'ASC' : 'DESC'
    #stats = current_user ? "status_id IN (4,3,2)" : "status_id = 4"
    #@sub = Submission.where(["name LIKE ? AND #{stats}", params[:term] + '%'])
    @users = User.where("last_name LIKE ?", "%#{params[:term]}%").order("#{params[:order]} #{dir}").paginate(:page => params[:page], :per_page => 15)
    if request.xhr?
        render :partial => 'user_table', :layout => false
    else
        render 'index'
    end
  end

  def add_user
    redirect_to :controller => :accounts, :action => :new
  end

  def update_user
    u =  params[:user]
    @user = User.find(params[:id])
    @user.first_name = u[:first_name]
    @user.last_name = u[:last_name]
    @user.email = u[:email]
    @user.institution = u[:institution]
    @user.role_id = u[:role_id]
    @user.password = params[:password] if (params[:password] == params[:password_confirmation]) && !params[:password].blank?
    @user.save

    if request.xhr?

      index
    else
      redirect_to :action => :index
    end
  end

  def edit_user
    action = params[:user_action]
    user = User.find(params[:id])
    partial = 'admin/user_table'
    case action
      when 'disable'
        user.enabled = false
        user.save
      when 'enable'
        user.enabled = true
        user.save
        if user.last_login.blank?
          AccountMailer.account_activated(user).deliver
        end
      when 'delete'
        User.delete(params[:id])
      when 'edit'
        @user = user
        @roles = Role.order('role_id ASC')
        partial = 'admin/user_edit'
    end
    
    params[:term] ||= ''
    params[:page] ||= '1'
    params[:order] ||= 'last_name'
    params[:dir] ||= 'up'

    dir = params[:dir] == 'up' ? 'ASC' : 'DESC'
    @users = User.order("#{params[:order]} #{dir}").paginate(:page => params[:page], :per_page => 15)

    if request.xhr?
      render :partial => partial, :layout => false
    else
      redirect_to :action => :index
    end

  end


end
