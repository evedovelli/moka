class Battle < ActiveRecord::Base
  resourcify
  paginates_per 5

  acts_as_taggable_on :hashtags

  has_many :options, dependent: :destroy
  has_many :votes, :through => :options
  belongs_to :user
  has_many :notifications

  accepts_nested_attributes_for :options, :allow_destroy => true

  attr_accessible :starts_at, :duration, :options_attributes, :options, :user, :hidden,
                  :title, :tag_list, :description

  validates :options,     :length       => { :minimum => 2, :maximum => 6 }
  validates :user,        :presence     => true
  validates :starts_at,   :presence     => true
  validates :duration,    :numericality => { :only_integer => true, :greater_than => 0, :less_than => 144000 }
  validates :title,       :length       => { :maximum => 120 }
  validates :description, :length       => { :maximum => 110 }

  def hide
    self.update_attributes({hidden: true})
  end

  def self.user_home(user, page)
    ids = user.friends.pluck(:id) << user.id
    return Battle.order(:starts_at).where(:user_id => ids).reverse_order.page(page)
  end

  def current?
    (starts_at <= DateTime.current) and (finishes_at >= DateTime.current)
  end

  def in_future?
    starts_at > DateTime.current
  end

  def finished?
    DateTime.current > finishes_at
  end

  def finishes_at
    return self.starts_at + self.duration.minutes
  end

  def self.hashtag_usage(hashtag)
    hashtags = Battle.hashtag_counts.where('LOWER(name) = LOWER(?)', "#{hashtag}")
    hashtag_counts = 0
    if hashtags.count > 0
      hashtag_counts = hashtags[0].taggings_count
    end
    return hashtag_counts
  end

  def self.with_hashtag(hashtag, page)
    return Battle.tagged_with(hashtag, on: :hashtags).order(:starts_at).reverse_order.page(page)
  end

  def fetch_hashtags
    self.hashtag_list = nil
    self.hashtag_list.add(
      title,
      parse: true,
      parser: HashtagParser
    )
    self.hashtag_list.add(
      description,
      parse: true,
      parser: HashtagParser
    )
    options.each do |option|
      self.hashtag_list.add(
        option.name,
        parse: true,
        parser: HashtagParser
      )
    end
  end

  def self.victorious(battles)
    victory_for = {}
    battles.each do |battle|
      most_votes = 0
      victorious_options = []
      battle.options.each do |option|
        victory_for[option.id] = false
        if option.number_of_votes() > most_votes
          victorious_options = [option]
          most_votes = option.number_of_votes()
        elsif option.number_of_votes() == most_votes and most_votes > 0
          victorious_options.push(option)
        end
      end
      victorious_options.each do |option|
        victory_for[option.id] = true
      end
    end
    return victory_for
  end

  def number_of_votes
    total = 0
    options.each do |option|
      total += option.number_of_votes
    end
    return total
  end

end
