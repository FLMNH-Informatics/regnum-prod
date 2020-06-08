

class AdminAccountMailer < ActionMailer::Base
  default from: "do-not-reply@phyloregnum.org"

  def account_created(user)
    @user = user
    byebug
    mail(to: User.admin_user_emails, subject: "New account created on Regnum")
  end

  def account_activated(user)
    @user = user
    mail(to: User.admin_user_emails, subject: "Account activated on Regnum")
  end

end