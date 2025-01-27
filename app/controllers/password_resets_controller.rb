class PasswordResetsController < ApplicationController

  def create
    user = User.find_by(email: params[:email])
    if user
      password_reset = PasswordReset.new(user_id: user.id)
      if password_reset.save
        UserMailer.password_reset(user, password_reset).deliver_now
        render json: { message: 'Password reset instructions sent to your email.' }, status: :ok
      else
        Rails.logger.debug("PasswordReset errors: #{password_reset.errors.full_messages}")
        render json: { error: 'Could not create password reset token.' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Email not found.' }, status: :not_found
    end
  end

  def update
    password_reset = PasswordReset.find_by(token: params[:id])

    if password_reset.nil? || password_reset.expired?
      render json: { error: 'Invalid or expired token.' }, status: :unauthorized
      return
    end

    if !confirm_password
      render json: { error: 'Passwords don\'t match'}, status: :unprocessable_entity
      return
    end

    user = password_reset.user
    if user.update(password_params)
      password_reset.destroy
      render json: { message: 'Password successfully updated.' }, status: :ok
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def confirm_password
    password_params[:password] == password_params[:password_confirmation]
  end
end
