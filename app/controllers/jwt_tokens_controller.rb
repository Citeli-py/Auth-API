class JwtTokensController < ApplicationController
  before_action :validate_user_token, only: [:regenerate_token]

  def regenerate_token
    @token = @user.generate_token
    render json: { token: @token }, status: :ok
  end

  private

  def validate_user_token
    result = UserService.validate_token(request)

    if result[:status] != :ok
      render json: { error: result[:error] }, status: result[:status]
    else
      @user = result[:user]
    end
  end
end
