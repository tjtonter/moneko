class OfferPdf < Prawn::Document
  include  ActionView::Helpers::SanitizeHelper

  LEFT = 35
  def initialize(offer, view)
    super(size: "A4", top_margin: 100, bottom_margin: 80)
    text offer.customer, :inline_format => true
    move_down 20
    text "TARJOUDUMME SUORITTAMAAN SIIVOUSTA SEURAAVASTI", :style => :bold
    move_down 20
    data = [
      ["Kohde", offer.target],
      ["Tarjouksemme sisältö", sanitize(offer.contents, tags: %w(b i u))],
      ["Työn suoritus", sanitize(offer.execution, tags: %w(b i u))],
      ["Toimitusaika", sanitize(offer.delivery, tags: %w(b i u))],
    ] +
    offer.services.map do |s|
      [s.title, view.number_to_currency(s.price)]
    end
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
  end
end
