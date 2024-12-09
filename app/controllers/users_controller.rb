class UsersController < ApplicationController
  before_action :validate_token, only: [:restricted] # Validação do token para ações protegidas

  def register
    user = User.new(user_params)
    if user.save
      token = user.generate_token
      render json: { message: 'User registered successfully', user: {id: user.id, email: user.email, token: token} }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: user_params[:email])

    if user&.authenticate(user_params[:password])
      token = user.generate_token
      render json: { message: 'Login successful', user: {id: user.id, email: user.email, token: token} }, status: :ok
    else
      render json: { errors: ['Invalid credentials'] }, status: :unauthorized
    end
  end

  def forgot
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
      render json: { message: 'Can\'t change password' }, status: :error
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
    params.require(:user).permit(:email, :password)
  end

  def extract_token_from_header
    # Pega o token Bearer do cabeçalho Authorization
    auth_header = request.headers['Authorization']
    # O formato esperado é 'Bearer <token>', então pegamos a segunda parte
    token = auth_header.to_s.split(' ').last if auth_header
    token
  end

  def validate_token

    token = extract_token_from_header
    if token.nil?
      render json: { errors: "Token is missing" }, status: :unauthorized
      return
    end

    jwt_token = JwtToken.find_by(token: token)
    if jwt_token.nil?
      render json: { errors: "Token is invalid" }, status: :unauthorized
      return
    end

    result = jwt_token.decode_token
    if result[:error]
      # Token expirado ou inválido
      render json: { errors: [result[:error]] }, status: :unauthorized
    end
  end

end
