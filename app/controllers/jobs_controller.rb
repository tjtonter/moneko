class JobsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    if params.has_key?(:date) and params.has_key?(:part)
      days = (params[:part] == '1..15') ? [1, 15] : [16, -1] 
      year, month = params[:date][:year], params[:date][:month]
      a = Date.new year.to_i, month.to_i, days[0]
      b = Date.new year.to_i, month.to_i, days[1]
      @jobs = @user.jobs.where({date: a..b}).order(date: :asc)
    else
      @jobs = @user.jobs.order(date: :desc)
    end
    pdf_jobs = @jobs
    @jobs = @jobs.paginate(:page => params[:page], :per_page => 12)
    respond_to do |format|
      format.html
      format.json { render :json => custom_json(@jobs) }
      format.pdf do
        pdf = JobsPdf.new(@user, pdf_jobs, view_context)
        send_data pdf.render, :filename => @user.username+"-tunnit.pdf",
          :disposition => "inline"
      end
    end
  end

  def create
    @user = current_user 
    @job = @user.jobs.new(job_params)
    @order = @job.order
    respond_to do |format|
      if @job.save
        flash[:notice] = "Uusi merkinta luotu"
        format.html {redirect_to order_path(@order)}
        format.json {render json: @job, status: :created, layout: !request.xhr?}
      else
        format.html {render 'new'}
        format.json {render json: @job.errors, status: :unprocessable_entity}
      end
    end
  end

  def new
    @user = User.find(params[:user_id])
    @order = Order.find(params[:order_id])
    @job = params[:job] ? @user.jobs.new(job_params) : @user.jobs.new
    @remote = request.xhr?
    respond_to do |format|
      format.html { render 'new', layout: !request.xhr? } 
    end
  end

  def edit
    @job = Job.find(params[:id])
    @user = User.find(params[:user_id])
    @order = @job.order
    @remote = request.xhr?
    respond_to do |format|
      format.html  { render layout: !request.xhr? }
    end
  end

  def update
    @user = current_user
    @job = Job.find(params[:id])
    respond_to do |format|
      if @job.update(job_params)
        format.json {render json: @job, status: :ok, layout: !request.xhr?}
      else
        format.json {render json: @job.errors, status: :unprocessable_entity}
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

    def sec_to_hhmm(sec)
      mm, ss = sec.divmod(60)
      hh, mm = mm.divmod(60)
      "#{hh}:#{mm}"
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
