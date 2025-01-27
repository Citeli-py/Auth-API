class UsersController < ApplicationController
  before_action :validate_user_token, only: [:restricted, :destroy_user, :logout] # Validação do token para ações protegidas

  def register
    if user_params[:password] != user_params[:password_confirmation]
      render json: {errors: ["Passwords don't match"]},  status: :unprocessable_entity
      return
    end

    user = User.new(user_params)
    if user.save
      UserMailer.confirmation_email(user).deliver_now
      render json: { message: 'User registered successfully, confirm your email', user: {id: user.id, email: user.email} }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: user_params[:email])

    if user.nil?
      render json: { errors: ['User don\'t exist'] }, status: :not_found
      return
    end

    if !UserService.emailValid?(user)
      render json: { errors: ['Email not confirmed'] }, status: :unauthorized
      return
    end

    if user&.authenticate(user_params[:password])
      token = user.generate_token
      render json: { message: 'Login successful', user: {id: user.id, email: user.email, token: token} }, status: :ok
    else
      render json: { errors: ['Invalid credentials'] }, status: :unauthorized
    end
  end

  def change_password
    user = User.find_by(email: forgot_params[:email])
    if user.nil?
      render json: { errors: ['Invalid Login'] }, status: :unprocessable_entity
      return
    end

    if not user.authenticate(forgot_params[:old_password])
      render json: { errors: ['Invalid Login'] }, status: :unprocessable_entity
      return
    end

    if forgot_params[:password] != forgot_params[:password_confirmation]
      render json: { errors: ['New passwords don\'t match'] }, status: :unprocessable_entity
      return
    end

    user.password = forgot_params[:password]

    if user.save()
      render json: { message: 'Password change sucess' }, status: :ok
    else
      render json: { message: 'Can\'t change password' }, status: :unprocessable_entity
    end
  end

  def destroy_user
    if @user.destroy
      render json: { message: "User Destroyed"}, status: :ok
    else
      render json: { message: "Can\'t destroy User"}, status: :unprocessable_entity
    end
  end


  def logout
    jwt_token = JwtToken.find_by(user_id: @user.id)

    if jwt_token.nil?
      render json: { message: "Token not found"}, status: :not_found
      return
    end

    if jwt_token.remover_token
      render json: { message: "User logged out"}, status: :ok
    else
      render json: { message: "Can\'t make changes"}, status: :unprocessable_entity
    end

  end

  def restricted
    render json: { message: 'Access granted to restricted area' }, status: :ok
  end

  private

  def forgot_params
    params.require(:user).permit(:email, :old_password, :password, :password_confirmation)
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def validate_user_token
    result = UserService.validate_token(request)

    if result[:status] != :ok
      render json: { error: result[:error] }, status: result[:status]
    else
      @user = result[:user]
    end
  end
end
