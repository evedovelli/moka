class FacebookSignUpNotification < Notification
  validates :sender, :presence => true
end
