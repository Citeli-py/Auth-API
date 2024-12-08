class UsersController < ApplicationController
  before_action :validate_token, only: [:restricted] # Validação do token para ações protegidas

  def register
    user = User.new(user_params)
    if user.save
      render json: { message: 'User registered successfully', user: user }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: user_params[:email])

    if user&.authenticate(user_params[:password])
      token = user.generate_token
      render json: { message: 'Login successful', token: token }, status: :ok
    else
      render json: { errors: ['Invalid credentials'] }, status: :unauthorized
    end
  end

  def restricted
    render json: { message: 'Access granted to restricted area' }, status: :ok
  end

  private

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
