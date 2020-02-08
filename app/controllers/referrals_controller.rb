class ReferralsController < ApplicationController
  before_action :authorize_request

  def index
    user = User.find_by(id: user_params[:user_id])
    head :not_found and return unless user

    render json: user.referrals.referred_users.map(&:public_attributes), status: :ok
  end

  private

  def user_params
    params.permit(:user_id)
  end
end
