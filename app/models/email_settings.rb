class EmailSettings < ActiveRecord::Base
  belongs_to :user

  attr_accessible :user_id, :new_follower, :facebook_friend_sign_up

  validates :user_id, :presence => true
end
