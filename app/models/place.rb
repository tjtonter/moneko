class Place < ActiveRecord::Base
  belongs_to :customer
  has_many :offers
end
