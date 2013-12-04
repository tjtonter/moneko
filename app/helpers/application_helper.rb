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
end
