class StatusMailer < ActionMailer::Base
  default :from => "do-not-reply@phylocode.org"

  def status_change(user, submission)
    @user = user
    @sub = submission
    mail(:to => @sub.user.email , :subject => ('Your submission for '+ @sub.name + ' has been ' + @sub.status.status))
  end
end
