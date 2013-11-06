class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)

    if @user.save
        redirect_to root_url, :notice => "Rekisteröity!"
    else
        render "new"
    end
  end

  private
    def user_params
        params.require(:user).permit(:email, :username, :name)
    end
end
