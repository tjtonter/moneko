class OrdersController < ApplicationController
  before_filter :load_offer_id
  def index
    @orders = params[:term] ? Order.where("title LIKE (?)", "%#{params[:term]}%") : Order.all
  
    respond_to do |format|
      format.html
      format.json { render json: custom_json(@orders) }
    end
  end

  def new
    @order = Order.new(order_params)    
    @users = User.all
    if request.xhr?
      render layout: false
    end
  end

  def create
    @order = Order.new(order_params)
    @order.number = create_number 
    @order.status = "waiting"
    respond_to do |format|
      if @order.save
        format.json {render json: @order, status: :created}
      else
        format.json {render json: @order.errors, status: :unprocessable_entity, layout: !request.xhr?}
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
    if @order.update(order_params)
      flash[:notice] = "Työmääräys päivitetty"
      redirect_to order_path(@order)
    else
      @users = User.all
      render 'edit'
    end
  end

  def edit
    @order = Order.find(params[:id])  
    @users = User.all
  end

  private
    def order_params
      params.require(:order).permit(:title, :description, :salary, :begin_at, :end_at, :status, :user_ids => [])
    end

    def load_offer_id
      @offer = Offer.find(params[:offer_id]) if params[:offer_id].present?
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
          :allDay => (order.begin_at.to_date != order.end_at.to_date),
          :url => order_path(order),
          :color => view_context.status_to_color(order.status)
        }
      end
      list.as_json
    end
end
