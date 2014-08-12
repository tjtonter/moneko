class Customer < ActiveRecord::Base
  has_many :offers
  has_many :places
end
