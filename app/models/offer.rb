class Offer < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  has_many :orders
  validates :customer, :presence => true
  validates :contents, :presence => true 

end
