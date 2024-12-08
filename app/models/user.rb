require 'digest'

class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }

  has_one :jwt_token

  def generate_token

    if (not self.jwt_token.nil?) and (not self.jwt_token.decode_token[:error])
      return self.jwt_token.token
    end

    # Token JWT básico, para aprendizado.
    header = { alg: 'HS256', typ: 'JWT' }
    payload = { user_id: self.id, exp: (Time.now + 10.minutes).to_i }
    secret = Rails.application.secret_key_base

    encoded_header = Base64.urlsafe_encode64(header.to_json)
    encoded_payload = Base64.urlsafe_encode64(payload.to_json)
    signature = Digest::SHA256.hexdigest("#{encoded_header}.#{encoded_payload}.#{secret}")

    token = "#{encoded_header}.#{encoded_payload}.#{signature}"
    JwtToken.create(user: self, token: token)
    token
  end
end
