class Api::V1::UsersController < ApplicationController
  skip_before_action :authorized, only: [:create]

  # POST /users
  def create
    @user = User.create(user_params)
    if @user.valid?
      @token = encode_token(user_id: @user.id)
      render json: { user: UserSerializer.new(@user), jwt: @token }, status: :created
    else
      render json: { message: 'failed to create user' }, status: :not_acceptable
    end
  end

  # PATCH /users
  def profile
    @user.update(user_params)
    if @user.valid?
      @token = encode_token(user_id: @user.id)
      render json: @user, status: :ok
    else
      render json: { message: 'Error updating user' }, status: :not_acceptable
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation, :avatar)
  end
end