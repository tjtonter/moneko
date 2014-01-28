module ApplicationHelper
  def status_to_class(status)
    case status
    when "waiting"
      return "info"
    when "active"
      return "danger"
    when "complete"
      return "success"
    when "billed"
      return "primary"
    end
  end
  def sortable(column, title = nil)
    title ||= column.titleize
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    link_to title, :sort => column, :direction => direction
  end
end
