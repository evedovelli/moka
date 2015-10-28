class Option < ActiveRecord::Base
  resourcify

  belongs_to :battle
  has_many :votes, dependent: :destroy
  has_many :users, through: :votes

  attr_accessible :name, :picture, :id
  has_attached_file :picture, :styles => {
                                :medium => {
                                  :geometry => "370x370#",
                                  :animated => false
                                },
                                :thumb => {
                                  :geometry => "100x100#",
                                  :animated => false
                                },
                                :icon => {
                                  :geometry => "44x44#",
                                  :animated => false
                                }
                              }

  validates :name, :presence => true
  validates :name, :length   => { maximum: 40 }
  validates_attachment :picture, :presence     => true,
                                 :content_type => { :content_type => /\Aimage\/.*\Z/ },
                                 :size         => { :in => 0..20.megabytes }

  def number_of_votes
    return votes.count
  end

end
