class JobsPdf < Prawn::Document
  def initialize(user, jobs, view)
    super(:page_layout => :landscape)
    @view = view
    text "Työtunti-ilmoitus", size: 14, style: :bold, align: :center
    text "Nimi:"
    text user.name, style: :bold
    move_down 30
    table(jobs_table(jobs), header: true, cell_style: 
          {borders: [:top, :bottom]}, width: 720) do
      column(0..1).width = 75
      column(3..6).width = 50
    end
    move_down 30
    text "Brutto yhteensä", align: :right
    text @view.number_to_currency(jobs.sum(:salary)), size: 14, style: :bold,
      align: :right
  end
  
  def jobs_table(jobs)
    [["Päivämäärä", "Työnumero", "Työ", "Alkoi", "Loppui", "Kesto", "Palkka"]] +
    jobs.map do |j|
      [
        @view.l(j.date, format: :short), 
        j.order.number, 
        j.order.title+" "+j.description, 
        j.begin.strftime("%H:%M"), 
        j.end.strftime("%H:%M"), 
        j.as_hours, 
        j.salary
      ]
    end
  end
end
