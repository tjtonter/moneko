class OffersController < ApplicationController
  class OfferReport < Prawn::Document
    include  ActionView::Helpers::SanitizeHelper

    LEFT = 35
    def initialize(options = {})
      super(:top_margin => 100, :bottom_margin => 100)
    end
    def to_pdf(offer)
      text offer.customer, :inline_format => true
      move_down 20
      text "TARJOUDUMME SUORITTAMAAN SIIVOUSTA SEURAAVASTI", :style => :bold
      move_down 20
      data = [
      ["Kohde", offer.target],
      ["Tarjouksemme sisältö", sanitize(offer.contents, tags: %w(b i u))],
      ["Työn suoritus", sanitize(offer.execution, tags: %w(b i u))],
      ["Toimitusaika", sanitize(offer.delivery, tags: %w(b i u))],
      ["Palvelumaksu", sanitize(offer.charge, tags: %w(b i u))]
      ]
      table(data, :cell_style => { :inline_format => true} ) do
        cells.borders = []
        cells.padding = 5
        column(0).font_style = :bold
      end

      canvas do
        repeat(:all) do
          draw_text "Raimo Saariaho", :at => [LEFT, bounds.top-60]
          draw_text "PALVELUTARJOUS", :at => [400, bounds.top-30]
          draw_text "Luottamuksellinen", :at => [400, bounds.top-45]
          draw_text "29.10.2013", :at => [400, bounds.top-60]
          font_size 10
          draw_text "Moneko oy", :at => [LEFT, 50]
          draw_text "Y-tunnus: 123456-Y", :at => [LEFT, 35]
          fill_color "fb8900"
          draw_text "MONEKO",
            :at => [LEFT, bounds.top-35],
            :style => :bold, 
            :size => 20
          move_down 70
          stroke_horizontal_rule
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
        pdf = OfferReport.new
        send_data pdf.to_pdf(@offer), filename: "hello.pdf", type: "application/pdf", disposition: "inline"
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
      params.require(:offer).permit(:customer, :target, :contents, :execution, :services, :delivery, :commit,
                                    services_attributes: [:id, :title, :price, :offer_id, :_destroy])
    end
end
