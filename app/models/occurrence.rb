class Occurrence < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  belongs_to :order

  def as_json(options = {}) 
    {"id" =>self.order.id,
    "title"=> self.order.title,
    "allDay"=> false,
    "start"=> self.start,
    "end"=> self.end, 
    "url"=>  order_path(self.order)
    }.as_json
  end
end
