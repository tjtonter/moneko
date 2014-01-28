class UsersController < ApplicationController
  helper_method :sort_column, :sort_direction
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @jobs = @user.jobs.order(sort_column + ' ' + sort_direction)
    @orders = Order.all
  end

  private
    def user_params
      params.require(:user).permit(:email, :username, :name)
    end
    def sort_column
      Job.column_names.include?(params[:sort]) ? params[:sort] : "id"
    end
    def sort_direction
      %[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end
