# app/services/user_services.rb
class UserService

  def self.emailValid?(user)
    emailConfirmation = EmailConfirmation.find_by(user_id: user.id)
    if emailConfirmation.nil?
      return false
    end

    emailConfirmation.confirmed?
  end

  def self.extract_token_from_header(request)
    auth_header = request.headers['Authorization']
    token = auth_header.to_s.split(' ').last if auth_header
    token
  end

  def self.validate_token(request)
    token = self.extract_token_from_header(request)
    return { error: "Token is missing", status: :unauthorized } if token.nil?

    jwt_token = JwtToken.find_by(token: token)
    return { error: "Token is invalid", status: :unauthorized } if jwt_token.nil?

    begin
      decoded_token = JwtToken.decode(token)
      { user: User.find(decoded_token[:user_id]), status: :ok }
    rescue => e
      { error: e.message, status: :unauthorized }
    end
  end
end
