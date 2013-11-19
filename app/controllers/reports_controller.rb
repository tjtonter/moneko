class ReportsController < ApplicationController
  def new
    @user = User.find(params[:user_id])
    @report = @user.reports.create
  end
end
