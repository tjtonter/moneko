class OffersController < ApplicationController
  def index
    @offers = Offer.all
  end

  def new
  end

  def create
  end

  def delete
  end

  def edit
  end
end
