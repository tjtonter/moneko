class Job < ActiveRecord::Base
  belongs_to :user
  belongs_to :order
  validates_presence_of :date, :duration, :begin, :end
end
