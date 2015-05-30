class Vote < ActiveRecord::Base
  resourcify

  belongs_to :stuff
  belongs_to :contest

  attr_accessible :stuff, :stuff_id, :contest, :contest_id

  validate  :created_at, :finished_contest
  validate  :created_at, :not_started_contest
  validates :contest,   :presence => true
  validates :stuff,    :presence => true
  validate  :stuff,    :belongs_to_contest

  def finished_contest
    if created_at && contest && contest.finishes_at
      errors.add(:created_at, I18n.t('messages.finished_contest')) unless contest.finishes_at > created_at
    end
  end

  def not_started_contest
    if created_at && contest && contest.starts_at
      errors.add(:created_at, I18n.t('messages.not_started_contest')) unless contest.starts_at < created_at
    end
  end

  def belongs_to_contest
    if stuff && contest
      errors.add(:stuff, I18n.t('messages.stuff_must_belong_to_contest')) unless contest.stuffs.include?(stuff)
    end
  end

  def error_message
    error_message = ""
    messages = self.errors.full_messages
    last_message = messages.pop
    messages.each do |message|
      error_message += " #{message};"
    end
    error_message += " #{last_message}."
    return error_message
  end

end
