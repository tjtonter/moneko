class Order < ActiveRecord::Base
  include IceCube
  include Rails.application.routes.url_helpers
  STATUSES = ["waiting", "active", "complete", "billed"]
  belongs_to :offer
  after_update :touch_tasks
  has_many :jobs, :dependent => :destroy
  has_many :tasks, :dependent => :destroy
  has_many :users, :through => :tasks
  accepts_nested_attributes_for :tasks
  serialize :rule, Hash
  validates_presence_of :title, :begin_at, :number
  validates_uniqueness_of :number
  validates_inclusion_of :status, :in => STATUSES,
    :message => "Status must be one of: #{STATUSES.join(" ,")}"
  validate :end_does_not_equal_begin

  def as_json(options={})
    s = converted_schedule
    if s
      array = s.occurrences_between(options[:start], options[:end])
    else 
      array = [self.begin_at]
    end
    array.map { |t| 
      {"id" =>self.id,
      "title"=> self.title,
      "allDay"=> false,
      "start"=> t,
      "end"=> t + t.duration, 
      "url"=>  order_path(self)
      }.as_json
    }
  end

  def schedule=(new_schedule)
    write_attribute(:rule, RecurringSelect.dirty_hash_to_rule(new_schedule).to_hash)
  end

  def converted_schedule
    if self.rule.empty? || self.rule.nil?
      return nil
    else
      the_schedule = Schedule.new(self.begin_at, :end_time => self.end_at)
      rule = RecurringSelect.dirty_hash_to_rule(self.rule)
      rule.until(self.until_at)
      the_schedule.add_recurrence_rule(rule)
      the_schedule
    end
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
