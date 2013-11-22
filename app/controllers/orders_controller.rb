class OrdersController < ApplicationController
  before_filter :load_offer_id
  def index
    @orders = params[:term] ? Order.where("title LIKE (?)", "%#{params[:term]}%") : Order.all
  
    respond_to do |format|
      format.html
      format.json { render json: @orders.map(&:title).as_json }
    end
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    @order.number = create_number 
    if @order.save
      flash[:notice] = "Uusi työmääräys luotu"
      redirect_to order_path(@order)
    else
      render "new"
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

    if @order.update(order_params)
      flash[:notice] = "Työmääräys päivitetty"
      redirect_to order_path(@order)
    else
      render 'edit'
    end
  end

  def edit
    @order = Order.find(params[:id])  
  end

  private
    def order_params
      params.require(:order).permit(:title, :description)
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

end
