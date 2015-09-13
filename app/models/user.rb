class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :login

  has_many :battles, dependent: :destroy
  has_many :friendships, dependent: :destroy
  has_many :friends, :through => :friendships
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id", dependent: :destroy
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user
  has_many :votes, dependent: :destroy
  has_many :options, :through => :votes

  # Setup accessible (or protected) attributes for your model
  attr_accessible :login, :username, :email, :password, :password_confirmation, :remember_me, :avatar, :name
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

end
