class OrdersController < ApplicationController
  load_and_authorize_resource except: [:new, :create]

  def index
    if params[:end] && params[:start]
      t1 = Date.strptime params[:start], "%s"
      t2 = Date.strptime params[:end], "%s"
      @orders = Order.where("begin_at < ? AND (end_at > ? OR until_at > ?)", t2, t1, t1)
    else
      @orders = Order.all  
    end
    respond_to do |format|
      format.html
      format.json { render json: @orders.as_json }
    end
  end

  def new
    @order = params[:order] ? Order.new(order_params) : Order.new
    if !@order.offer.nil?
      @order.description = @order.offer.contents
    end
    @order.until_at ||= @order.end_at
    @users = User.all
    @remote = true
    respond_to do |format|
      format.html { render layout: !request.xhr? }
      format.json { render layout: false }
    end
  end

  def create
    @order = Order.new(order_params)
    @order.number = create_number 
    @order.status = "waiting"
    respond_to do |format|
      if @order.save
        format.json {render json: @order, status: :created}
        format.html {redirect_to orders_path()}
      else
        @users = User.all
        format.json {render json: @order.errors, status: :unprocessable_entity, layout: !request.xhr?}
        format.html {render 'edit'}
      end
    end
  end

  def show
    @order = Order.find(params[:id])
  end
  
  def destroy
    Order.destroy(params[:id])
    flash[:notice] = "Työmääräys poistettu"
    redirect_to orders_path
  end

  def update
    @order = Order.find(params[:id])
    params[:order][:user_ids] ||= []
    respond_to do |format|
      if @order.update(order_params)
        flash[:notice] = "Työmääräys päivitetty"
        format.json {render json: @order, status: :accepted}
        format.html {redirect_to orders_path}
      else
        format.json {render json: @order.errors, status: :unprocessable_entity}
        format.html do
          @users = User.all
          render 'edit'
        end
      end
    end
  end

  def edit
    @order = Order.find(params[:id])  
    @users = User.all
    @remote= false
  end
  
  private
    def order_params
      params.require(:order).permit(:id, :offer_id, :title, :description, :salary, :allday, :begin_at, :end_at, :until_at, :status, 
                                    :rule , user_ids: [])
    end

    def load_offer_id
      @offer = Offer.find(order_params) if params[order_params].present?
    end
    
    def create_number
      year = Date.today.year    
      year = year - 2000
      year = year * 10000
      year = year + (Order.ids.empty? ? 0 : Order.ids.max)
    end
    def custom_json(orders)
      list = orders.map do |order|
        { :id => order.id,
          :title => order.title,
          :start => order.begin_at,
          :end => order.end_at,
          :allDay => order.end_at ? (order.begin_at.to_date != order.end_at.to_date) : true,
          :url => order_path(order),
          :color => view_context.status_to_color(order.status),
          :user_ids => order.users.map { |user| user.id }
        }
      end
      list.as_json
    end
    def custom_json2(orders)
      list = Array.new
      orders.each do |order|
        if order.rule?
          s = Schedule.from_hash(order.rule)
	  list = s.all_occurrences.map do |time|
            { :id => order.id,
              :title => order.title,
              :start => time,
              :end => time+s.duration,
              :allDay => order.end_at ? (order.begin_at.to_date != order.end_at.to_date) : true,
              :url => order_path(order),
              :color => view_context.status_to_color(order.status),
              :user_ids => order.users.map { |user| user.id }
            }
	  end
	end
      end
      list.as_json
    end
end
