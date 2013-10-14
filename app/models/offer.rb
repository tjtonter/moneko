class Offer < ActiveRecord::Base
  include ActionView::Helpers::TextHelper

  validates :customer, :presence => true
  validates :contents, :presence => true 

end
