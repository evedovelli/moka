class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :login

  has_many :battles, dependent: :destroy

  # Setup accessible (or protected) attributes for your model
  attr_accessible :login, :username, :email, :password, :password_confirmation, :remember_me


  validates :username, :uniqueness => { :case_sensitive => false },
                       :presence => true
  validate :username, :reserved_usernames

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
end
