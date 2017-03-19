# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

  #TODO should turn below on -- need to fix forms first
  #protect_from_forgery
  
  helper_method :current_user
  helper_method :logged_in?
  helper_method :requires_logged_in
  helper_method :requires_admin
  helper_method :requires_editor
  helper_method :requires_user
  
  def faq
     render 'shared/faq', :layout => (logged_in? ? 'application' : 'public')
  end

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    session.has_key?(:user_id) && !session[:user_id].nil? && User.find(session[:user_id]).enabled == true
  end

  def requires_logged_in
    no_pass if !logged_in?
  end

  def requires_admin
    no_pass if !logged_in? || !current_user.is_admin?
  end

  def requires_editor
    no_pass if !logged_in? || !current_user.is_a_reviewer?
  end

  def requires_user
    no_pass if !logged_in? || !current_user.is_user?
  end

  def requires_a_editor_or_admin
    no_pass if !logged_in? || !(current_user.is_a_reviewer? || current_user.is_admin?)
  end

  # makes sure params id matches
  # session user_id    like for a user
  # editing their own account info
  # this is funnnnnky
  def requires_current_user
    no_pass if !logged_in? || (params[:id].to_i != session[:user_id].to_i)
  end

  def no_pass
    #or do something else
    redirect_to :login
  end
  
  def unauthorized_request
    if request.xhr? 
      render :text => 'you do not have permission to complete this request', :layout => false
    else
      render :text => 'unauthorized'
    end
  end
end
