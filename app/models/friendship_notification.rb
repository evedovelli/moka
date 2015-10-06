class FriendshipNotification < Notification
  validates :sender, :presence => true
end
