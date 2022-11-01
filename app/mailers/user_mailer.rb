class UserMailer < ApplicationMailer

  def new_user_email
    @user = params[:user]

    mail(to: @user.email, subject: "You got Successfully Registration!")
  end

  def send_bulk_email(email, subject, data)
    @user = email
    @subject = subject
    @body=data
    mail(to: @user, subject: @subject, messages: @body)
  end
end
