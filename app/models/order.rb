class Order < ActiveRecord::Base
  STATUSES = ["waiting", "active", "complete", "billed"]
  belongs_to :offer
  has_many :jobs, :dependent => :destroy
  has_many :tasks, :dependent => :destroy
  has_many :users, :through => :tasks
  accepts_nested_attributes_for :tasks

  validates_presence_of :title, :begin_at, :end_at, :number
  validates_uniqueness_of :number
  validates_inclusion_of :status, :in => STATUSES,
    :message => "Status must be one of: #{STATUSES.join(" ,")}"
end
