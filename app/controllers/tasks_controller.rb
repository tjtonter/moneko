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
  def custom_json(collection)
    list = collection.map do |value|
      { :id => value.id,
        :title => value.order.title,
        :start => value.order.begin_at,
        :end => value.order.end_at,
        :url => new_user_job_path(params[:user_id]) + "?order_id=#{value.order_id}"
      }
    end
    list.as_json
  end
end
