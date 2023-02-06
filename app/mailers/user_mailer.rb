class UserMailer < ApplicationMailer

  def new_user_email
    @user = params[:user]

    mail(to: @user.email, subject: "You got Successfully Registration!")
  end

  def send_bulk_email(email, name, subject, data)
    @user = email.strip
    @subject = subject
    name = name&.strip.present? ? " #{name.presence}" : ''
    @body = data.gsub(' {name}', name)
    mail(to: @user, subject: @subject, messages: @body)
  end
end
