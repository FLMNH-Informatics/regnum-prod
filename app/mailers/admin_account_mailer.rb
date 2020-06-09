

class AdminAccountMailer < ActionMailer::Base
  default from: "do-not-reply@phyloregnum.org"

  def account_created(user)
    @user = user
    mail(to: User.admin_user_emails, subject: "New account created on Regnum for #{user.full_name}")
  end

  def account_activated(user)
    @user = user
    mail(to: User.admin_user_emails, subject: "Account activated on Regnum for #{user.full_name}")
  end

end