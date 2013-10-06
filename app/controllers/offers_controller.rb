class OffersController < ApplicationController
  def index
    @offers = Offer.all
  end

  def new
    @offer = Offer.new
  end

  def create
    @offer = Offer.new(params[:offer])

    if @offer.save
      redirect_to @offer
    else
      render 'new'
    end
  end

  def delete
  end

  def edit
  end
end
