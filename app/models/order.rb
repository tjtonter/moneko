include IceCube
require 'googleauth'
require 'google/apis/calendar_v3'
class Order < ActiveRecord::Base
  STATUSES = ["waiting", "active", "complete", "billed"]
  belongs_to :offer
  after_create :insert_google_calendar_event
  after_update :update_google_calendar_event
  after_destroy :delete_google_calendar_event
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
  attr_accessor :recurring

  def recurring?
    return self.ical?
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

  def as_event
    event = Google::Apis::CalendarV3::Event.new(
      summary: self.title,
      description: "#{self.description}, Palkka: #{self.salary}",
      start: {
        date_time: self.begin_at.to_datetime.rfc3339,
        time_zone: self.begin_at.time_zone.name
      },
      end: {
        date_time: self.end_at.to_datetime.rfc3339,
        time_zone:  self.end_at.time_zone.name
      },
      attendees: self.users.map{|user| Hash[:email, user.email]}
    )
    if self.recurring?
      event.recurrence = ["RRULE:#{self.ical}"]
    end
    event 
  end

  def get_calendar
    calendar = Google::Apis::CalendarV3::CalendarService.new
    scope = ['https://www.googleapis.com/auth/calendar']
    auth = Google::Auth.get_application_default(scope)
    auth.fetch_access_token!
    calendar.authorization = auth
    calendar
  end
  
  def insert_google_calendar_event
    begin
      calendar = get_calendar
      result = calendar.insert_event('primary', self.as_event)
      self.gid = result.id
      self.save
    rescue
    end 
  end

  def update_google_calendar_event
    begin
      calendar = get_calendar
      result = calendar.update_event('primary', self.gid, self.as_event)
      puts result
    rescue
    end
  end

  def delete_google_calendar_event(gid=self.gid)
    begin
      calendar = get_calendar
      result = calendar.delete_event('primary', gid)
      puts result
    rescue
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
