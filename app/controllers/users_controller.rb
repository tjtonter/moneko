class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @jobs = @user.jobs.all
    @orders = Order.all
  end

  private
    def user_params
      params.require(:user).permit(:email, :username, :name)
    end
end
