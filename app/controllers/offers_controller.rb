class OffersController < ApplicationController
  class OfferReport < Prawn::Document
    def initialize(options = {})
      super(:top_margin => 140, :bottom_margin => 100)
    end
    def to_pdf
      100.times do 
        text "Hello world!"
      end
      text "Hello again!"

      canvas do
        repeat(:all) do
          draw_text "Raimo Saariaho", :at => [bounds.left+10, bounds.top-20]
          draw_text "MONEKO", :at => [bounds.left+10, bounds.top-50], :style => :bold, :color => "#ff0000" 
        end
      end
      render
    end
  end

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
    respond_to do |format|
      format.html
      format.pdf do
        pdf = OfferReport.new
        send_data pdf.to_pdf, filename: "hello.pdf", type: "application/pdf", disposition: "inline"
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

    if @offer.update(params[:offer].permit(:customer, :target, :contents, :execution, :delivery, :charge, :commit))
      redirect_to @offer
    else
      render "edit"
    end 
  end
end
