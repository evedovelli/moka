class Contest < ActiveRecord::Base
  resourcify

  has_and_belongs_to_many :stuffs
  has_many :votes, dependent: :destroy

  attr_accessible :finishes_at, :starts_at, :stuffs, :stuff_ids

  validates :stuffs,    :length   => { :minimum => 2 }
  validates :starts_at,   :presence => true
  validates :finishes_at, :presence => true
  validate  :timings

  def timings
    if starts_at && finishes_at
      errors.add(:finishes_at, I18n.t('messages.finishes_after_starts')) unless starts_at < finishes_at
    end
  end

  def self.current
    return Contest.all.delete_if {|e|
      (e.starts_at > DateTime.current) or (e.finishes_at < DateTime.current)
    }.sort_by{|e| e.starts_at}
  end

  def current?
    Contest.current.include? self
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

  def results_by_stuff
    total = Vote.where(:contest_id => id).count
    return [] unless total != 0

    results = []
    stuffs.each do |stuff|
      stuff_total = Vote.where(:contest_id => id, :stuff_id => stuff.id).count
      results.push({
        value: stuff_total,
        percent: (stuff_total*100.0/total).round(1),
        color: stuff.color,
        highlight: stuff.highlight,
        label: stuff.name,
        picture: stuff.picture
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
      datas.push(Vote.where(:created_at => hour..next_hour, :contest_id => id).count)
      hour = next_hour
    end

    datasets.push({
      label:           "Contest #{id}",
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
