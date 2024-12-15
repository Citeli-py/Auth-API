require "json"
require "base64"
require "jwt"

class JwtToken < ApplicationRecord
  belongs_to :user
  validates :token, presence: true

  SECRET = Rails.application.secret_key_base
  EXP = 10.minutes.from_now

  def self.encode(payload, exp=EXP)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET)
  end

  # Decodifica um token JWT e valida a assinatura
  def self.decode(token)
    begin
      decoded = JWT.decode(token, SECRET, true, { algorithm: 'HS256' })[0]
      HashWithIndifferentAccess.new(decoded)
    rescue JWT::ExpiredSignature
      raise 'Token has expired'
    rescue JWT::VerificationError
      raise 'Invalid token signature'
    rescue JWT::DecodeError => e
      raise "Invalid token: #{e.message}"
    end
  end

  # Verifica se o token expirou
  def expired?
    payload = JwtToken.decode(self.token)
    payload[:exp] < Time.now.to_i
  rescue => e
    # Retorna verdadeiro caso ocorra qualquer erro ao decodificar
    true
  end
end
