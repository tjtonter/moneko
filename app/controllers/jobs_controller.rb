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
    @user = current_user 
    @job = @user.jobs.new(job_params)
    @job.description = @job.order.title
    @order = @job.order
    respond_to do |format|
      if @job.save
        format.json {render json: @job, status: :created, layout: !request.xhr?}
      else
        format.json {render json: @job.errors, 
          status: :unprocessable_entity}
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

    def custom_json(jobs)
      list = jobs.map do |job|
        { :id => job.id,
          :title => job.description,
          :start => job.order.begin_at.strftime('%Y-%m-%d %H:%m'),
          :end => job.order.end_at.strftime('%Y-%m-%d %H:%m'),
          :allDay => (job.order.begin_at.day == job.order.end_at.day ? true : false)
        }
      end
      list.as_json
    end
    def seasons
      jobs = Job.order(date: :asc)
      if jobs.empty?
        return []
      else
        r = jobs.first.date..jobs.last.date
        r.map {|d| d.day<15 ? d.strftime("%m/%Y/A") : d.strftime("%m/%Y/L")}.uniq
      end
    end
end
