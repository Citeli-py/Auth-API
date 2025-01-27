class EmailConfirmation < ApplicationRecord
  belongs_to :user

  before_create :generate_unique_token

  # Gera um token único para o usuário
  def generate_unique_token
    self.token = SecureRandom.uuid
  end

  # Verifica se o e-mail foi confirmado
  def confirmed?
    confirmed_at.present?
  end

  # Confirma o e-mail do usuário
  def confirm!
    update!(confirmed_at: Time.current)
  end
end
