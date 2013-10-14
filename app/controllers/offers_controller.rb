class OffersController < ApplicationController
  def index
    @offers = Offer.all
  end

  def new
    @offer = Offer.new
  end

  def create
    @offer = Offer.new(params[:offer].permit(:customer, :target, :contents, :execution, :delivery, :charge, :commit))

    if @offer.save
      redirect_to @offer
    else
      render "new"
    end
  end

  def show
    @offer = Offer.find(params[:id])
  end

  def delete
  end

  def edit
    @offer = Offer.find(params[:id])
  end

  def update
    @offer = Offer.find(params[:id])

    if @offer.update(params[:offer].permit(:customer, :target, :contents, :execution, :delivery, :charge, :commit))
      redirect_to @offer
    else
      render "edit"
    end 
  end
end
