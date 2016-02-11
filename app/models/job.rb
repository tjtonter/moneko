class Job < ActiveRecord::Base
  belongs_to :user
  belongs_to :order
  validates_presence_of :date, :begin, :end
#  validates :duration, :format => { :with => /\d+(\.\d+)/, 
#    :message => "Anna kesto muodossa 0..24 tai 0.5..23.5" }
  def as_hours
    msec = self.end-self.begin
    if msec < 0
      h = (1.day+msec)/3600
    else
      h = msec/3600
    end
    h
  end
end
