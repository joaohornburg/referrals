class ApplicationController < ActionController::API
  def authorize_request
    token = request.headers['Authorization']&.split(' ')&.last
    decoded = JsonWebToken.decode(token)
    head :unauthorized unless User.where(id: decoded[:user_id]).exists?
  rescue JWT::DecodeError => e
    head :unauthorized
  end
end
