class OrdersController < ApplicationController
  before_filter :load_offer_id
  def index
    @orders = @offer.present? ? @offer.orders : Order.all
  end

  def new
    @offer = Offer.find(params[:offer_id])
  end

  def create
    @offer = Offer.find(params[:offer_id])
    @order = @offer.orders.create(order_params)
    if @order.save
      flash[:notice] = "Uusi työmääräys luotu"
      redirect_to offer_order_path(@offer, @order)
    else
      render "new"
    end
  end

  def show
    @offer = Offer.find(params[:offer_id])
    @order = @offer.orders.find(params[:id])
  end
  
  def destroy
    Order.destroy(params[:id])
    flash[:notice] = "Työmääräys poistettu"
    redirect_to orders_path
  end

  def update
  end

  def edit
  end

  private
    def order_params
      params.require(:order).permit(:title, :description)
    end

    def load_offer_id
      @offer = Offer.find(params[:offer_id]) if params[:offer_id].present?
    end
end
