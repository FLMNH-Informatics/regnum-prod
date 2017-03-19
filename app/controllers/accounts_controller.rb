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

  def create
    info = params[:account]

    @user = User.new
    @user.first_name = info[:first_name]
    @user.last_name = info[:last_name]
    @user.email = info[:email]
    @user.institution = info[:institution]
    @user.password = info[:password]
    @user.password_confirmation = info[:password_confirmation]

    if verify_recaptcha(:model => params, :message => "Oh! It's error with reCAPTCHA!") && @user.save
      #if admin is logged in and creating account
      AccountMailer.account_created(@user).deliver
      if !current_user.nil? && current_user.is_admin?
        redirect_to :controller => :admin, :action => :index
      else
        
        redirect_to :login
      end
    else
      redirect_to :action => :new , :notice => 'could not create account'
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