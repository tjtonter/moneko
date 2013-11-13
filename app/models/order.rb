class Order < ActiveRecord::Base
  belongs_to :offer

  validates_presence_of :title, :description
end
