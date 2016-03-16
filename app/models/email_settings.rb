class EmailSettings < ActiveRecord::Base
  belongs_to :user

  attr_accessible :new_follower, :user_id

  validates :user_id, :presence => true
end
