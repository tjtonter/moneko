class UsersController < ApplicationController
  load_and_authorize_resource except: [:create]
  def index
    @users = User.all
    @today = Date.today
    if @today.day.between?(16,31)
      @past = Date.new(@today.year, @today.month, 1)
    else
      @past = @today-1.month
      @past = Date.new(@past.year, @past.month, 16)
    end
  end

  def show
    @user = User.find(current_user.id)
    @jobs = @user.jobs.order("date desc").limit(15)
    t1 = 2.weeks.ago
    t2 = 2.weeks.from_now
    @orders = Order.where("begin_at < ? AND (end_at > ? OR until_at > ?)", t2, t1, t1)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice]="Uusi käyttäjä luotu"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    params[:user].delete(:password) if params[:password].blank?
    params[:user].delete(:password_confirmation) if params[:password].blank?
    puts params
    if @user.update(user_params)
      flash[:notice] = "Käyttäjä päivitetty"
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end

  private
    def user_params
      params.require(:user).permit(:email, :username, :password, :password_confirmation, :name, :gcal, :roles => [])
    end
end
