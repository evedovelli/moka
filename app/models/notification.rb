class Notification < ActiveRecord::Base
  resourcify
  paginates_per 15

  belongs_to :user
  belongs_to :sender, :class_name => 'User'
  belongs_to :vote

  attr_accessible :user, :user_id, :sender, :sender_id, :vote, :vote_id

  validates :user, :presence => true
  validates :type, :presence => true
end
