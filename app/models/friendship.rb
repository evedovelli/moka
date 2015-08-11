class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, :class_name => 'User'

  attr_accessible :friend_id, :user_id

  validates :user,   :presence => true
  validates :friend, :presence => true
  validates_uniqueness_of :user_id, :scope => :friend_id, :message => I18n.t('messages.uniqueness_friend')
end
