class Battle < ActiveRecord::Base
  resourcify

  has_many :options, dependent: :destroy
  has_many :votes, :through => :options

  accepts_nested_attributes_for :options, :allow_destroy => true

  attr_accessible :starts_at, :duration, :options_attributes, :options

  validates :options,   :length   => { :minimum => 2 }
  validates :starts_at, :presence => true
  validates :duration,  :numericality => { :only_integer => true, :greater_than => 0 }

  def self.current
    return Battle.all.delete_if {|e|
      (e.starts_at > DateTime.current) or (e.starts_at + e.duration.minutes < DateTime.current)
    }.sort_by{|e| e.starts_at}
  end

  def current?
    Battle.current.include? self
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

  def results_by_option
    total = votes.count
    return [] unless total != 0

    results = []
    options.each do |option|
      option_total = Option.find(option.id).votes.count
      results.push({
        value: option_total,
        percent: (option_total*100.0/total).round(1),
        color: option.color,
        highlight: option.highlight,
        label: option.name,
        picture: option.picture
      })
    end

    return results
  end

  def results_by_hour
    return {} unless not in_future?

    datasets = []
    labels = []
    datas = []

    hour = starts_at
    hour = hour.change(:sec => 0)
    hour = hour.change(:min => 0)
    while hour < (starts_at + duration.minutes) and not hour.future?
      next_hour = hour + 1.hour
      labels.push(hour.strftime('%d/%m/%y - %kh'))
      datas.push(votes.where(:created_at => hour..next_hour).count)
      hour = next_hour
    end

    datasets.push({
      label:           "Battle #{id}",
      fillColor:       "rgba(255,107,10,0.5)",
      strokeColor:     "rgba(255,107,10,0.8)",
      highlightFill:   "rgba(255,107,10,0.75)",
      highlightStroke: "rgba(255,107,10,1)",
      data: datas
    })

    return {
      labels: labels,
      datasets: datasets
    }
  end

end
