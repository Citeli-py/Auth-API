class PasswordReset < ApplicationRecord
  belongs_to :user

  before_create :generate_token_and_set_expiry

  validates :token, uniqueness: true
  #validates :expires_at, presence: true

  def expired?
    self.expires_at <= Time.now
  end

  private

  def generate_token_and_set_expiry
    self.token = SecureRandom.hex(20) # Gera um token único
    self.expires_at = 2.hours.from_now
  end
end
