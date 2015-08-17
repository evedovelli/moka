class Battle < ActiveRecord::Base
  resourcify
  paginates_per 5

  has_many :options, dependent: :destroy
  has_many :votes, :through => :options
  belongs_to :user

  accepts_nested_attributes_for :options, :allow_destroy => true

  attr_accessible :starts_at, :duration, :options_attributes, :options, :user, :hidden, :title

  validates :options,   :length   => { :minimum => 2, :maximum => 6 }
  validates :user,      :presence => true
  validates :starts_at, :presence => true
  validates :duration,  :numericality => { :only_integer => true, :greater_than => 0 }

  def hide
    self.update_attributes({hidden: true})
  end

  def self.user_home(user, page)
    ids = user.friends.pluck(:id) << user.id
    return Battle.order(:starts_at).where(:user_id => ids).reverse_order.page(page)
  end

  def current?
    (starts_at < DateTime.current) and (starts_at + duration.minutes > DateTime.current)
  end

  def in_future?
    starts_at > DateTime.current
  end

  def finishes_at
    return self.starts_at + self.duration.minutes
  end

end
