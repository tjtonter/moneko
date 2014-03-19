class JobsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    if params.has_key?(:date) and params.has_key?(:part)
      days = (params[:part] == '1..15') ? [1, 15] : [16, -1] 
      year, month = params[:date][:year], params[:date][:month]
      a = Date.new year.to_i, month.to_i, days[0]
      b = Date.new year.to_i, month.to_i, days[1]
      flash[:notice] = "Näytetään merkinnät ajalta #{l a} .. #{l b}"
      @jobs = @user.jobs.where({date: a..b}).order(date: :asc)
    else
      @jobs = @user.jobs.order(date: :desc)
    end
    @jobs = @jobs.paginate(:page => params[:page], :per_page => 12)
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
