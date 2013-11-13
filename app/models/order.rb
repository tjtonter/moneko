class Order < ActiveRecord::Base
  belongs_to :offer

  validates_presence_of :title, :description, :number
  validates_uniqueness_of :number
end
