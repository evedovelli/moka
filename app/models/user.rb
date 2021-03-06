class User < ActiveRecord::Base
  rolify
  paginates_per 10

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  attr_accessor :login

  has_many :battles, dependent: :destroy
  has_many :friendships, dependent: :destroy
  has_many :friends, :through => :friendships
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id", dependent: :destroy
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user
  has_many :votes, dependent: :destroy
  has_many :options, :through => :votes
  has_many :notifications, dependent: :destroy
  has_many :sent_notifications, :class_name => "Notification", :foreign_key => "sender_id", dependent: :destroy
  has_many :identities, dependent: :destroy
  has_one  :email_settings, dependent: :destroy
  has_many :facebook_friendships, dependent: :destroy
  has_many :facebook_friends, :through => :facebook_friendships
  has_many :comments, dependent: :destroy

  # Setup accessible (or protected) attributes for your model
  attr_accessible :login, :username, :email, :password, :password_confirmation,
                  :remember_me, :avatar, :name, :unread_notifications, :language
  has_attached_file :avatar, :styles => {
                               :medium => {
                                 :geometry => "300x300#",
                                 :animated => false
                               },
                               :small => {
                                 :geometry => "100x100#",
                                 :animated => false
                               },
                               :icon => {
                                 :geometry => "44x44#",
                                 :animated => false
                               }
                             }, :default_url => "avatar/:style/missing.png"

  validates_attachment :avatar, :content_type => { :content_type => /\Aimage\/.*\Z/ },
                                :size         => { :in => 0..20.megabytes }
  validates :username, :uniqueness => { :case_sensitive => false },
                       :presence => true
  validate :username, :has_valid_characters
  validate :username, :reserved_usernames
  validates :email, :presence => true

  def has_valid_characters
    if username !~ /^[a-zA-Z0-9_]+$/
      errors.add(:username, I18n.t('messages.invalid_characters'))
    end
  end

  def reserved_usernames
    case username
    when 'sign_in'
      errors.add(:username, I18n.t('messages.invalid_username'))
    when 'sign_up'
      errors.add(:username, I18n.t('messages.invalid_username'))
    when 'sign_out'
      errors.add(:username, I18n.t('messages.invalid_username'))
    when 'facebook_friends'
      errors.add(:username, I18n.t('messages.invalid_username'))
    when 'sign_in_popup'
      errors.add(:username, I18n.t('messages.invalid_username'))
    else
      return
    end
  end

  # Overriding devise authentication method to allow login using email or username
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  # Overrides numeric id by username for referring to user in URLs
  def to_param
    username
  end

  def self.find_for_oauth(auth, signed_in_resource)
    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?
      email = auth.info.email
      user = User.where(:email => email).first if email

      # Create the user if it's a new registration
      if user.nil?
        # Get an initial unique username (there is a small chance this username
        # gets used inbetween User.new and user.save!)
        username_part = email.split("@").first.parameterize.underscore
        username = username_part.dup
        num = 1
        while (User.where(username: username).count > 0)
          username = "#{username_part}#{num}"
          num = num + 1
        end

        user = User.new(
          name: auth.info.name,
          email: email,
          username: username,
          password: Devise.friendly_token[0,20]
        )
        user.skip_confirmation! if auth.info.verified
        user.email_settings = EmailSettings.create(user_id: user.id)
        user.save!

        user.notify_user_friends(auth.credentials)
      end
    end

    # Associate the identity with the user if needed
    if (identity.user == nil)
      identity.user = user
      identity.save!
    elsif (identity.user != user)
      return nil
    end

    # Fill up user info when missing
    if not user.name
      user.update_attributes(name: auth.info.name)
    end

    return user
  end

  def sorted_battles(page)
    return battles.order(:starts_at).reverse_order.page(page)
  end

  def is_friends_with?(friend)
    if friendships && friendships.exists?(:friend_id => friend.id)
      return true
    end
    return false
  end

  def get_friendship_with(friend)
    return friendships.where(:friend_id => friend.id).first
  end

  def vote_for(battle)
    return votes.joins(:option).where('options.battle_id' => battle.id).first
  end

  def voted_for_options(battles)
    voted_for = {}
    battles.each do |battle|
      battle.options.each do |option|
        voted_for[option.id] = options.find_by_id(option.id) != nil
      end
    end
    return voted_for
  end

  def receive_vote_notification_from(sender, vote)
    VoteNotification.create(
      user: self,
      sender: sender,
      vote: vote
    )
    self.increment_unread_notification
  end

  def receive_friendship_notification_from(sender)
    FriendshipNotification.create(
      user: self,
      sender: sender
    )
    self.increment_unread_notification
  end

  def receive_facebook_sign_up_notification_from(sender)
    FacebookSignUpNotification.create(
      user: self,
      sender: sender
    )
    self.increment_unread_notification
  end

  def receive_comment_notification_from(sender, option)
    CommentNotification.create(
      user: self,
      sender: sender,
      option: option
    )
    self.increment_unread_notification
  end

  def receive_comment_answer_notification_from(sender, option)
    CommentAnswerNotification.create(
      user: self,
      sender: sender,
      option: option
    )
    self.increment_unread_notification
  end

  def reset_unread_notifications
    self.update_attributes({unread_notifications: 0})
  end

  def receive_friendship_email_from(sender)
    if (not self.email_settings) || (self.email_settings.new_follower)
      FriendshipMailer.new_follower(sender, self).deliver
    end
  end

  def receive_facebook_sign_up_email_from(sender)
    if (not self.email_settings) || (self.email_settings.facebook_friend_sign_up)
      FriendshipMailer.facebook_friend_sign_up(sender, self).deliver
    end
  end

  def increment_unread_notification
    self.update_attributes({unread_notifications: unread_notifications + 1})
  end

  def self.search(user_name, page)
    if user_name
      user_name.downcase!
      return where('LOWER(name) LIKE ? OR LOWER(username) LIKE ?', "%#{user_name}%", "%#{user_name}%").order(:confirmed_at).page(page)
    else
      return User.order(:confirmed_at).page(page)
    end
  end

  def following(page)
    return self.friends.order(:username).page(page)
  end

  def followers(page)
    return self.inverse_friends.order(:username).page(page)
  end

  def get_facebook_friends(page)
    return self.facebook_friends.order(:username).page(page)
  end

  def connected_to_facebook?
    return self.identities.where(:provider => "facebook").size > 0
  end

  def has_friendship_with(friend)
    return (self.friends.where(id: friend.id).size > 0)
  end

  def has_facebook_friendship_with(friend)
    return (self.facebook_friends.where(id: friend.id).size > 0)
  end

  def update_facebook_friend(facebook_friend)
    friend = Identity.search_friend(facebook_friend["id"], "facebook")
    if (friend) &&
       (not self.has_friendship_with(friend)) &&
       (not self.has_facebook_friendship_with(friend))
      return facebook_friendships.create(
        user: self,
        facebook_friend: friend
      )
    elsif (friend) &&
       (self.has_friendship_with(friend)) &&
       (self.has_facebook_friendship_with(friend))
      facebook_friendship = facebook_friendships.where(
        facebook_friend_id: friend.id
      ).first
      return facebook_friendship.destroy
    end
    return false
  end

  def notify_user_friends(credentials)
    if credentials
      friends = self.find_friends_from_facebook(credentials)
      friends.each do |friend|
        self.update_facebook_friend(friend)
      end
      self.facebook_friendships.each do |facebook_friendship|
        facebook_friendship.facebook_friend.receive_facebook_sign_up_notification_from(self)
        facebook_friendship.facebook_friend.receive_facebook_sign_up_email_from(self)
      end
    end
  end

  def find_friends_from_facebook(credentials)
    @graph = Koala::Facebook::API.new(credentials.token)
    return @graph.get_connections("me", "friends") || []
  end

  def welcome?
    if friends.count > 4
      return false
    else
      return true
    end
  end

  def first_battle?
    if battles.count > 0
      return false
    else
      return true
    end
  end

end
