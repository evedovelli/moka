class VoteNotification < Notification
  validates :vote, :presence => true
  validates :sender, :presence => true
end
