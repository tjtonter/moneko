class Order < ActiveRecord::Base
  STATUSES = ["waiting", "active", "complete", "billed"]
  belongs_to :offer
  has_many :jobs, :dependent => :destroy
  has_many :tasks, :dependent => :destroy
  has_many :users, :through => :tasks
  accepts_nested_attributes_for :tasks

  validates_presence_of :title, :begin_at, :number
  validates_uniqueness_of :number
  validates_inclusion_of :status, :in => STATUSES,
    :message => "Status must be one of: #{STATUSES.join(" ,")}"
  validate :end_does_not_equal_begin

  protected
    def end_does_not_equal_begin
      @errors.add(:end_at, "ei voi olla sama kuin alkuaika") if self.end_at == self.begin_at
    end
end
