# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :authenticate_request!, only: %i[create login]

  def create
    user = User.new(user_params.except(:confirm_password))

    user_params = params[:user]
    if user_params[:password] != user_params[:confirm_password]
      render json: { errors: 'Passwords don\'t match' }, status: :bad_request
    elsif user.save
      render json: { message: 'User created successfully' }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :bad_request
    end
  end

  def login
    user = User.find_by(email: params[:email].to_s.downcase)

    if user&.authenticate(params[:password])
      auth_token = JsonWebToken.encode(user_id: user.id)
      render json: { auth_token: auth_token }, status: :ok
    else
      render json: { error: 'Invalid username / password' }, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :confirm_password)
  end
end
