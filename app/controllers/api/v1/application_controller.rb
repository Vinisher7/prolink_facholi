class Api::V1::ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Basic::ControllerMethods

  private

  def authorize_user!
    return if authenticate_with_http_basic { |email, password| try_auth(email, password) }

    render json: { error: 'Credenciais inválidas!' }, status: :unauthorized
  end

  def try_auth(email, password)
    return false if email.blank? || password.blank?

    user = fetch_user(email)
    if user&.valid_password?(password)
      @current_user = user
      true
    else
      false
    end
  end

  def fetch_user(email)
    User.find_by(email: email)
  end
end
