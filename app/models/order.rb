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
  #validates :until_at, presence: true, unless: "rule.nil?"
  validates_uniqueness_of :number
  validates_inclusion_of :status, :in => STATUSES,
    :message => "Status must be one of: #{STATUSES.join(" ,")}"
  validate :end_does_not_equal_begin

  def recurring?
    return self.rule.nil? ? false : true
  end

  def rule=(new_schedule)
    if RecurringSelect.is_valid_rule?(new_schedule) && new_schedule != "{}"
      rule = RecurringSelect.dirty_hash_to_rule(new_schedule)
      rule.until self.until_at
      write_attribute(:rule, rule.to_hash)
      write_attribute(:ical, rule.to_ical)
    else
      write_attribute(:rule, nil)
      write_attribute(:ical, nil)
    end
  end

  def duration
    self.end_at-self.begin_at
  end

  def converted_schedule
    unless self.recurring?
      return "null"
    else
      the_schedule = Schedule.new(self.begin_at)
      rule = RecurringSelect.dirty_hash_to_rule(self.rule)
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
