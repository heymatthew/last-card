class UsersController < ApplicationController
  def create
    session[:user_id] = user.id
    redirect_to "/"
  end

  private

  def user
    User.find_or_create_by(email: info.email) do |new_user|
      new_user.firstname = info.first_name
      new_user.name = info.name
      new_user.image = info.image
    end
  end

  def info
    request.env["omniauth.auth"].info
  end
end
