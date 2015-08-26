class Option < ActiveRecord::Base
  resourcify

  belongs_to :battle
  has_many :votes, dependent: :destroy
  has_many :users, through: :votes

  attr_accessible :name, :picture, :id
  has_attached_file :picture, :styles => { :medium => "370x370#", :thumb => "120x120#" }

  validates :name, :presence => true
  validates_attachment :picture, :presence     => true,
                                 :content_type => { :content_type => /\Aimage\/.*\Z/ },
                                 :size         => { :in => 0..20.megabytes }

  def number_of_votes
    return votes.count
  end

end
