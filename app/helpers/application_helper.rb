module ApplicationHelper
  def status_to_class(status)
    case status
    when "waiting"
      return "danger"
    when "active"
      return "info"
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
