class UserMailer < ApplicationMailer
  default :from => "brvast1 <brvast@gmail.com>"
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.notify_comment.subject
  #
  def notify_comment(event, user)
        @user = user
        @event = event
        mail(:to => user.email, :subject => "New Commentlater235")
  end
end
