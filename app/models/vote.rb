class Vote < ActiveRecord::Base
  resourcify

  belongs_to :option
  belongs_to :battle

  attr_accessible :option, :option_id, :battle, :battle_id

  validate  :created_at, :finished_battle
  validate  :created_at, :not_started_battle
  validates :battle,   :presence => true
  validates :option,    :presence => true
  validate  :option,    :belongs_to_battle

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

  def belongs_to_battle
    if option && battle
      errors.add(:option, I18n.t('messages.option_must_belong_to_battle')) unless battle.options.include?(option)
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
