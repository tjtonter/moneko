class UsersController < ApplicationController
  def index
    @users = User.all
    @today = Date.today
    if @today.day.between?(16,31)
      @past = Date.new(@today.year, @today,month, 1)
    else
      @past = @today-1.month
      @past = Date.new(@past.year, @past.month, 16)
    end
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
