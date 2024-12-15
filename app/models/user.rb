require 'digest'

class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }

  has_one :jwt_token

  def generate_token

    if not (self.jwt_token.nil? or self.jwt_token.expired?)
      return self.jwt_token.token
    end

    if not self.jwt_token.nil?
      self.jwt_token.destroy()
    end

    token = JwtToken.encode({user_id: self.id})
    self.jwt_token = JwtToken.create!(user: self, token: token)
    token
  end

end
