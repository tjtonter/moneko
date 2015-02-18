class TasksController < ApplicationController
  def index
    @user = User.find(current_user)
    @orders = @user.orders
    respond_to do |format|
      format.html
      format.json { render json: @orders }
    end 
  end
end
