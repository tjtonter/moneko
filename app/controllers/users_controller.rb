class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @times = Array.new
    (0..20).each do |h|
      @times << ["#{h}", h]
      @times << ["#{h+0.5}", h+0.5]
    end
    @user = User.find(params[:id])
    @orders = Order.all
  end

  private
    def user_params
      params.require(:user).permit(:email, :username, :name)
    end
end
