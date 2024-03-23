class AccountsController < ApplicationController
  
  before_filter :requires_current_user, :only => [:show,:update]

  def new
    if request.xhr?
      render :new, :layout => false
    end
  end
  #def login
  def login
    if request.xhr?
      render :login, :layout => false
    end
  end

  def help
    render(:help, layout: false)  if request.xhr?
  end

  def create
    info = params[:account]
    email = info[:email]
    password = info.delete :password
    password_confirmation = info.delete :password_confirmation

    if email.blank?
      redirect_to action: :new, notice: "You must have a valid email."
      return
    end

    if User.has_email? email
      flash[:notice] = "There is already a user with the email #{email}"
      redirect_to action: :new, account: info
      return
    end

    @user = User.new
    @user.first_name = info[:first_name]
    @user.last_name = info[:last_name]
    @user.email = email
    @user.institution = info[:institution]
    @user.password = password
    @user.password_confirmation = password_confirmation

    if @user.password != @user.password_confirmation
      flash[:error] = "The passwords entered do not match."
      redirect_to action: :new, account: info
      return
    end

    if @user.password.length < 6
      flash[:error] = "Please choose a longer password"
      redirect_to action: :new, account: info
      return
    end

    begin
      #if verify_recaptcha(:model => params, :message => "Oh! It's error with reCAPTCHA!") && @user.save
      if @user.save
        AccountMailer.account_created(@user).deliver_now
        AdminAccountMailer.account_created(@user).deliver_now
        if !current_user.nil? && current_user.is_admin?
          redirect_to :controller => :admin, :action => :index
        else
          flash[:notice] = "Account created and pending.  You will be notified via email at #{@user.email} when your account is approved."
          redirect_to :login
        end
      else
        flash[:notice] = "Could not create account."
        redirect_to action: :new, account: info
      end
    rescue
      flash[:notice] = "Sorry, something went wrong"
      redirect_to action: :new, account: info
    end
  end

  def update
    u = params[:user]
    @user = User.find(params[:id])
    @user.first_name = u[:first_name]
    @user.last_name = u[:last_name]
    @user.email = u[:email]
    @user.institution = u[:institution]
    @user.password = params[:password] if (params[:password] == params[:password_confirmation]) && !params[:password].blank?

    @user.save
    redirect_to :action => :show, :notice => 'Account Updated!'
  end

  def show
    @user = User.find(params[:id])
    params
  end

  def logout
    session.delete(:user_id)
    session.delete(:user_email)
    #session.destroy
    redirect_to :search
  end


  def authenticate
    user = User.authenticate( params[:account][:email], params[:account][:password] )
    if !user.nil?  && user.enabled == true
      session[:user_id] = user.id
      session[:user_email] = user.email
      redirect_to :my_submission
    else
      redirect_to :login, :notice => "Incorrect email/password combination!"
    end
  end


end