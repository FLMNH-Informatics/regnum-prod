

class AdminAccountMailer < ActionMailer::Base
  default from: "do-not-reply@phyloregnum.org",
          to: User.admin_user_emails

  def account_created(user)
    @user = user
    mail(subject: "New account created on Regnum")
  end

  def account_activated(user)
    @user = user
    mail(subject: "Account activated on Regnum")
  end

end