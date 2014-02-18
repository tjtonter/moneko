class TasksController < ApplicationController
  def index
    @tasks = User.find(params[:user_id]).tasks
    respond_to do |format|
      format.html
      format.json { render json: custom_json(@tasks) }
    end
  end

  def new
  end

  private
  def custom_json(tasks)
    list = tasks.map do |t|
      { :id => t.id,
        :title => t.order.title,
        :start => t.order.begin_at,
        :end => t.order.end_at,
        :url => new_user_job_path(params[:user_id]) + "?order_id=#{t.order_id}",
        :allDay => (t.order.begin_at.day == t.order.end_at.day ? false : true)
      }
    end
    list.as_json
  end
end
