class JobsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    if params[:date]
      m, y, s = params[:date].split('/')
      m = m.to_i
      y = y.to_i
      if s == 'A'
        r = Date.new(y,m,1)..Date.new(y,m,15)
      else
        r = Date.new(y,m,16)..Date.new(y,m,-1)
      end
      @jobs = @user.jobs.where({date: r})
    else
      @jobs = @user.jobs.all
    end
    @m = seasons
    respond_to do |format|
      format.html
      format.json { render :json => custom_json(@jobs) }
    end
  end

  def create
    @user = User.find(params[:user_id])
    @job = @user.jobs.new(job_params)
    @job.description = @job.order.title
    @order = @job.order
    if @job.save
      if request.xhr?
        render @job
      else
        redirect_to user_path(current_user)
      end
    else
      if request.xhr?
        render 'new', status: :unprocessable_entity, layout: false
      else
        flash[:notice] = "Tapahtui virhe"
        redirect_to user_path(current_user)
      end
    end
  end

  def new
    @user = User.find(params[:user_id])
    @order = Order.find(params[:order_id])
    @job = @user.jobs.new
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
      params.require(:job).permit(:order_id, :user_id, :duration, 
                                  :description, :date, :salary, :begin, :end)
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
    def seasons
      jobs = Job.order(date: :asc)
      r = jobs.first.date..jobs.last.date
      r.map {|d| d.day<15 ? d.strftime("%m/%Y/A") : d.strftime("%m/%Y/L")}.uniq
    end
end
