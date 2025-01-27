require 'digest'

class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }

  after_create :generate_token, :create_email_confirmation

  has_one :jwt_token, dependent: :destroy
  has_one :email_confirmation, dependent: :destroy
  has_one :password_reset, dependent: :destroy

  def generate_token

    ActiveRecord::Base.transaction do

      if not self.jwt_token.nil?
        self.jwt_token.destroy
      end

      token = JwtToken.encode({user_id: self.id, NONCE: SecureRandom.uuid})
      self.jwt_token = JwtToken.create!(user: self, token: token)
      return token
    end

  end

  def create_email_confirmation
    EmailConfirmation.create!(user: self);
  end

end
