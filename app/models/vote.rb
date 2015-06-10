class Vote < ActiveRecord::Base
  resourcify

  belongs_to :option
  has_one :battle, :through => :option

  attr_accessible :option, :option_id

  validate  :created_at, :finished_battle
  validate  :created_at, :not_started_battle
  validates :option,     :presence => true

  def finished_battle
    if created_at && battle && battle.finishes_at
      errors.add(:created_at, I18n.t('messages.finished_battle')) unless battle.finishes_at > created_at
    end
  end

  def not_started_battle
    if created_at && battle && battle.starts_at
      errors.add(:created_at, I18n.t('messages.not_started_battle')) unless battle.starts_at < created_at
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
