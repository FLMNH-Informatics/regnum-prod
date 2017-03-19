class AccountMailer < ActionMailer::Base
  default :from => "do-not-reply@phylocode.org"

  def account_created(user)
  	@user = user
    mail(:to => @user.email, :bcc => 'cdell@flmnh.ufl.edu,ncellinese@flmnh.ufl.edu,chrisdell@gmail.com' , :subject => ('Account Created on Phyloregnum!')) 
  end

  def account_activated(user)
  	@user = user
  	mail(:to => @user.email, :bcc => 'cdell@flmnh.ufl.edu,ncellinese@flmnh.ufl.edu,chrisdell@gmail.com', :subject => ('Your Phyloregnum account is active!'))
  end
end
