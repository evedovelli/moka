class Battle < ActiveRecord::Base
  resourcify

  has_many :options, dependent: :destroy
  has_many :votes, :through => :options
  belongs_to :user

  accepts_nested_attributes_for :options, :allow_destroy => true

  attr_accessible :starts_at, :duration, :options_attributes, :options, :user

  validates :options,   :length   => { :minimum => 2 }
  validates :user,      :presence => true
  validates :starts_at, :presence => true
  validates :duration,  :numericality => { :only_integer => true, :greater_than => 0 }

  def self.all
    return super.sort{|x, y| y.starts_at <=> x.starts_at }
  end

  def self.current
    return Battle.all.delete_if {|e|
      (e.starts_at > DateTime.current) or (e.starts_at + e.duration.minutes < DateTime.current)
    }.sort_by{|e| e.starts_at}
  end

  def current?
    (starts_at < DateTime.current) and (starts_at + duration.minutes > DateTime.current)
  end

  def remaining_time
    seconds = starts_at + duration.minutes - DateTime.current
    hours = (seconds / 1.hour).floor
    seconds -= hours.hours
    minutes = (seconds / 1.minute).floor
    seconds -= minutes.minutes
    seconds = seconds.floor
    return { hours: hours, minutes: minutes, seconds: seconds }
  end

  def in_future?
    starts_at > DateTime.current
  end

end
