class Order < ActiveRecord::Base
  include IceCube
  STATUSES = ["waiting", "active", "complete", "billed"]
  belongs_to :offer
  after_update :touch_tasks
  has_many :jobs, :dependent => :destroy
  has_many :tasks, :dependent => :destroy
  has_many :users, :through => :tasks
  accepts_nested_attributes_for :tasks
  serialize :rule
  attr_accessor :rrule
  validates_presence_of :title, :begin_at, :number
  validates_uniqueness_of :number
  validates_inclusion_of :status, :in => STATUSES,
    :message => "Status must be one of: #{STATUSES.join(" ,")}"
  validate :end_does_not_equal_begin
  def as_json(options = {})
    s = Schedule.from_hash(rule)
    list = s.all_occurrences.map do |t|
      {
        id: self.id,
        title: self.title,
        allDay: false,
        start: t,
        :end => t + s.duration,
        url: Rails.application.routes.url_helpers.orders_path(self)
      
    end
    list.to_json
  end
  protected
    def end_does_not_equal_begin
      @errors.add(:end_at, "ei voi olla sama kuin alkuaika") if self.end_at == self.begin_at
    end
    def touch_tasks
      self.tasks.each do |t|
        t.touch
      end
    end
end
