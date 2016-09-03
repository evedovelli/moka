class CommentAnswerNotification < Notification
  validates :sender, :presence => true
  validates :option, :presence => true
end
