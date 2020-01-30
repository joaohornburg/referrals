class UsersController < ApplicationController  
  def create
    user = User.new(user_params)
    if user.save
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
      render json: { errors: 'not found' }, status: :not_found
    end
  end

  def destroy
    User.find_by(id: params[:id]).destroy
    head :ok
  end

  private

  def user_params
    params.permit(:name, :email, :password)
  end
end
