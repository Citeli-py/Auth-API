require "json"
require "base64"

class JwtToken < ApplicationRecord
  belongs_to :user
  validates :token, presence: true

  def decode_token
    # Divida o token em suas três partes: header, payload e signature
    header, payload, signature = self.token.split('.')

    # Decodificar o header e o payload (em Base64)
    decoded_payload = JSON.parse(Base64.urlsafe_decode64(payload))

    # Verificar se o token expirou
    if decoded_payload['exp'].to_i < Time.now.to_i
      raise 'Token has expired'
    end

    # Verificar se a assinatura é válida
    secret = Rails.application.secret_key_base
    expected_signature = Digest::SHA256.hexdigest("#{header}.#{payload}.#{secret}")
    if expected_signature != signature
      raise 'Invalid token signature'
    end

    # Retornar o payload se o token for válido
    decoded_payload
  rescue => e
    { error: e.message }
  end

end
