class EmailConfirmationsController < ApplicationController

  def confirm
    email_confirmation = EmailConfirmation.find_by(token: params[:token])

    if email_confirmation.nil?
      render json: { error: "Token inválido" }, status: :not_found
      return
    end

    if email_confirmation.confirmed?
      render json: { message: "E-mail já confirmado." }, status: :ok
      return
    end

    email_confirmation.confirm!
    render json: { message: "E-mail confirmado com sucesso!" }, status: :ok
  end
end
