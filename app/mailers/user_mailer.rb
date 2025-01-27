class UserMailer < ApplicationMailer

  def welcome_email
    @user = params[:user]
    mail(to: @user.email, subject: "Bem vindo! sua conta foi criada")
  end

  def confirmation_email(user)
    @user = user
    @token = EmailConfirmation.find_by(user_id: user.id).token
    @url = "http://127.0.0.1:3000/email_confirmations/#{@token}"
    mail(to: @user.email, subject: "Confirme seu e-mail")
  end

  def password_reset(user, password_reset)
    @user = user
    puts password_reset.token
    @reset_url = "http://127.0.0.1:3000/password_resets/#{password_reset.token}"
    mail(to: @user.email, subject: 'Password Reset Instructions')
  end

end
