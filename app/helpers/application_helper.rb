module ApplicationHelper
  def next_status(st)
    Order::STATUSES[(Order::STATUSES.find_index(st)+1)%Order::STATUSES.length]
  end
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
  def status_to_color(status)
    case status
    when "waiting"
      return "#5bc0de"
    when "active"
      return "#428bca"
    when "complete"
      return "#5cb85c"
    when "billed"
      return "#999"
    end
  end
  def sortable(column, title = nil)
    title ||= column.titleize
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    link_to title, :sort => column, :direction => direction
  end
  def sort_column
    Job.column_names.include?(params[:sort]) ? params[:sort] : "id"
  end
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
