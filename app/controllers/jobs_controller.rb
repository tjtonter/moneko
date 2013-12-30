class JobsController < ApplicationController
  def index
    user = User.find(params[:user_id])
    @jobs = user.jobs

    respond_to do |format|
      format.html
      format.json { render :json => custom_json(@jobs) }
    end
  end

  def create
    @user = User.find(params[:user_id])
    @job = @user.jobs.new(job_params)
    @job.description = @job.order.title
    if @job.save
      if request.xhr?
        @jobs = Job.all
        render partial: 'table'
      else
        redirect_to user_path(current_user)
      end
    else
      flash[:notice] = "Tapahtui virhe"
      redirect_to user_path(current_user)
    end
  end

  def new
    @user = User.find(params[:user_id])
    @order = Order.find(params[:order_id])
    respond_to do |format|
      format.html do 
        if request.xhr?
          render 'new', :layout => false
        else
          render 'new'
        end
      end
    end
  end

  def destroy
    Job.delete(params[:id])
    flash[:notice] = "Työ poistettu"
    redirect_to user_path(current_user)
  end
  private
    def job_params
      params.require(:job).permit(:order_id, :user_id, :duration, :description, :date, :salary, 
                                  :begin, :end)
    end

    def custom_json(user)
      list = user.map do |value|
        { :id => value.id,
          :title => value.description,
          :start => value.order.begin_at,
          :end => value.order.end_at
        }
      end
      list.as_json
    end
end
