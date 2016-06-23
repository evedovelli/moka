class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :option
  attr_accessible :body
end
