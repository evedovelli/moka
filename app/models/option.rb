class Option < ActiveRecord::Base
  resourcify

  belongs_to :battle
  has_many :votes, dependent: :destroy
  has_many :users, through: :votes
  has_many :comments, dependent: :destroy

  attr_accessible :name, :picture, :id
  has_attached_file :picture, :styles => {
                                :facebook => {
                                  :geometry => "1200x630#",
                                  :animated => false
                                },
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

  def ordered_votes(page)
    return self.votes.order(:created_at).page(page)
  end

  def ordered_comments(page)
    return self.comments.order(:created_at).reverse_order.page(page)
  end
end
