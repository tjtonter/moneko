class TasksController < ApplicationController
  def index
    @user = User.find(current_user)
    if params[:end] && params[:start]
      t1 = Date.strptime params[:start], "%s"
      t2 = Date.strptime params[:end], "%s"
      @orders = @user.orders.where("begin_at < ? AND (end_at > ? OR until_at > ?)", t2, t1, t1)
    else
      @orders = @user.orders
    end
    #@orders = @user.orders
    respond_to do |format|
      format.html
      format.json { render json: @orders }
    end 
  end
end
