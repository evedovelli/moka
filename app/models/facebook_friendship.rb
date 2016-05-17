class FacebookFriendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :facebook_friend, :class_name => 'User'

  attr_accessible :facebook_friend, :user

  validates :user,            :presence => true
  validates :facebook_friend, :presence => true
  validates_uniqueness_of :user_id, :scope => :facebook_friend_id, :message => I18n.t('messages.uniqueness_facebook_friend')
end
