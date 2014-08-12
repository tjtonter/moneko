class Offer < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  has_many :orders
  belongs_to :customer
  belongs_to :place
  has_many :services, :dependent => :destroy
  accepts_nested_attributes_for :services, allow_destroy: true, reject_if: :all_blank
  validates :contents, :presence => true
  validates :services, :presence => true
end
