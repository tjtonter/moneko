class OrdersController < ApplicationController
  before_filter :load_offer_id
  def index
    @orders = @offer.present? ? @offer.orders : Order.all
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
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
end
