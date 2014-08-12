class OffersController < ApplicationController
  load_and_authorize_resource
  def index
    @offers = Offer.all
  end

  def new
    @offer = Offer.new
    @offer.services.build
  end

  def create
    @offer = Offer.new(offer_params)
    if @offer.save
      redirect_to offers_path
    else
      render "new"
    end
  end

  def show
    @offer = Offer.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        pdf = OfferPdf.new(@offer, view_context)
        send_data pdf.render, filename: "#{@offer.target}.pdf",
          type: "application/pdf", disposition: "inline"
      end
    end
  end

  def delete
  end

  def edit
    @offer = Offer.find(params[:id])
  end

  def update
    @offer = Offer.find(params[:id])

    if @offer.update(offer_params)
      redirect_to @offer
    else
      render "edit"
    end 
  end
  private
    def offer_params
      params.require(:offer).permit(:customer_id, :place_id, :contents, :execution, 
                                    :services, :delivery, :commit,
                                    services_attributes: [:id, :title, :price, 
                                      :offer_id, :_destroy])
    end
end
