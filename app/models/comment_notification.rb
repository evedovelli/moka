class CommentNotification < Notification
  validates :sender, :presence => true
  validates :option, :presence => true
end
