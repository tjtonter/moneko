class Offer < ActiveRecord::Base
  validates :customer, :presence => true
  validates :contents, :presence => true 
end
