class AuthenticationController < ApplicationController
    def login
      user = User.find_by(email: auth_params[:email])

      if user&.authenticate(auth_params[:password])
        token = JsonWebToken.encode(email: user.email, user_id: user.id)
        render json: {token: token, expiration: 24.hours.from_now, email: user.email }, status: :ok
      else
        head :unauthorized
      end
    end

    private

    def auth_params
      params.permit(:email, :password)
    end
end
