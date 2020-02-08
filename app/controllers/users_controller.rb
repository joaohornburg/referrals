class UsersController < ApplicationController  
  before_action :authorize_request, except: :create
  
  def create
    user = UserCreator.new(user: create_user_params.to_h, referral_code: referral_code_params[:referral_code]).create
    if user.valid? && user.persisted?
      render json: user, status: :created
    else
      render json: { errors: user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def show
    user = User.find_by(id: params[:id])
    if user
      render json: user, status: :ok
    else
      head :not_found
    end
  end

  def destroy
    User.find_by(id: params[:id])&.destroy
    head :no_content
  end

  def update
    user = User.find_by(id: params[:id])
    head :not_found and return unless user

    if user.update(update_user_params)
      render json: user, status: :ok
    else
      render json: { errors: user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  private

  def create_user_params
    params.permit(:name, :email, :password)
  end

  def referral_code_params
    params.permit(:referral_code)
  end

  def update_user_params
    params.permit(:name, :password, :balance)
  end
end
