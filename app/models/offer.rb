class Offer < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  has_many :orders
  has_many :places
  has_one :customer
  has_many :services, :dependent => :destroy
  accepts_nested_attributes_for :services, allow_destroy: true, reject_if: :all_blank
  validates :customer, :presence => true
  validates :contents, :presence => true
  validates :services, :presence => true
end
