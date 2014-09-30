class TasksController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    if params[:start] && params[:end]
      @orders = @user.orders.where("begin_at < ? AND end_at > ?", params[:end], params[:start])
    else
      @orders = @user.orders
    end
    respond_to do |format|
      format.html
      format.json { render json: custom_json(@orders) }
    end
  end

  def new
  end

  private
  def custom_json(orders)
    list = orders.map do |o|
      { :id => o.id,
        :title => o.title,
        :start => o.begin_at,
        :end => o.end_at,
        :url => new_user_job_path(params[:user_id]) + "?order_id=#{o.id}",
        :allDay => (o.begin_at.day == o.end_at.day ? false : true),
        :color => view_context.status_to_color(o.status) 
      }
    end
    list.as_json
  end
end
