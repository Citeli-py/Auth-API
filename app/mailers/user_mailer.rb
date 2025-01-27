class UserMailer < ApplicationMailer

  def welcome_email
    @user = params[:user]
    mail(to: @user.email, subject: "Bem vindo! sua conta foi criada")
  end

  def confirmation_email(user)
    @user = user
    @token = EmailConfirmation.find_by(user_id: user.id).token
    @url = "#{ENV["FRONTEND_URL"]}/email_confirmations/#{@token}"
    mail(to: @user.email, subject: "Confirme seu e-mail")
  end

  def password_reset(user, password_reset)
    @user = user
    puts password_reset.token
    @reset_url = "#{ENV["FRONTEND_URL"]}/password_resets/#{password_reset.token}"
    mail(to: @user.email, subject: 'Password Reset Instructions')
  end

end
