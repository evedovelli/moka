class Battle < ActiveRecord::Base
  resourcify

  has_many :options, dependent: :destroy
  has_many :votes, :through => :options

  accepts_nested_attributes_for :options, :allow_destroy => true

  attr_accessible :finishes_at, :starts_at, :options_attributes, :options

  validates :options,     :length   => { :minimum => 2 }
  validates :starts_at,   :presence => true
  validates :finishes_at, :presence => true
  validate  :timings

  def timings
    if starts_at && finishes_at
      errors.add(:finishes_at, I18n.t('messages.finishes_after_starts')) unless starts_at < finishes_at
    end
  end

  def self.current
    return Battle.all.delete_if {|e|
      (e.starts_at > DateTime.current) or (e.finishes_at < DateTime.current)
    }.sort_by{|e| e.starts_at}
  end

  def current?
    Battle.current.include? self
  end

  def remaining_time
    seconds = finishes_at - DateTime.current
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
    while hour < finishes_at and not hour.future?
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
