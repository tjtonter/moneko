class Order < ActiveRecord::Base
  STATUSES = ["waiting", "active", "complete", "billed"]
  belongs_to :offer

  validates_presence_of :title, :description, :number
  validates_uniqueness_of :number
  validates_inclusion_of :status, :in => STATUSES,
    :message => "Status must be one of: #{STATUSES.join(" ,")}"
end
