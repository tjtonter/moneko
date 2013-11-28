class JobsController < ApplicationController
  def create
    @user = User.find(params[:user_id])
    @job = @user.jobs.new(job_params)
    @job.description = @job.order.title
    if @job.save
      redirect_to user_path(current_user)
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
      params.require(:job).permit(:order_id, :user_id, :duration, :description, :date)
    end
end
