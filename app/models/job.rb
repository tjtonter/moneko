class Job < ActiveRecord::Base
  belongs_to :user
  belongs_to :order
  validates_presence_of :date, :begin, :end
#  validates :duration, :format => { :with => /\d+(\.\d+)/, 
#    :message => "Anna kesto muodossa 0..24 tai 0.5..23.5" }
  def as_hours
    msec = self.end-self.begin
    msec/3600
  end
end
