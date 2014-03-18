class Job < ActiveRecord::Base
  belongs_to :user
  belongs_to :order
  validates_presence_of :date, :duration, :begin, :end
  validates :duration, :numericality => {:greater_than_or_equal_to => 0,
    :message => "Arvo on oltava positiivinen" }
#  validates :duration, :format => { :with => /\d+(\.\d+)/, 
#    :message => "Anna kesto muodossa 0..24 tai 0.5..23.5" }
end
