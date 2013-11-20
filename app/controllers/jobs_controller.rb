class JobsController < ApplicationController
  def create
    @user = User.find(params[:user_id])
    @job = @user.jobs.new(job_params)
    if @job.save
      redirect_to user_path(current_user)
    else
      flash[:notice] = "Tapahtui virhe"
      redirect_to user_path(current_user)
    end
  end
  private
    def job_params
      params.require(:job).permit(:order_id, :user_id, :duration, :description, :date)
    end
end
