class UsersController < ApplicationController  
  def create
    user = User.new(create_user_params)
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
      # render json: {errors: user.errors.full_messages }, status: :ok
    else
      render json: { errors: user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  private

  def create_user_params
    params.permit(:name, :email, :password)
  end

  def update_user_params
    params.permit(:name, :password, :balance)
  end
end
