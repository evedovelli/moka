class Comment < ActiveRecord::Base
  resourcify
  paginates_per 8

  belongs_to :user
  belongs_to :option
  has_one :battle, through: :option
  attr_accessible :body, :user_id

  validates :body, presence: true
  validates :user_id, presence: true
end
