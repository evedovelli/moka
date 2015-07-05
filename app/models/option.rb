class Option < ActiveRecord::Base
  resourcify

  belongs_to :battle
  has_many :votes, dependent: :destroy

  attr_accessible :name, :picture, :id
  has_attached_file :picture, :styles => { :medium => "370x370#", :thumb => "120x120#" }

  validates :name, :presence => true
  validates_attachment :picture, :presence     => true,
                                 :content_type => { :content_type => /\Aimage\/.*\Z/ },
                                 :size         => { :in => 0..20.megabytes }

  def color
    colors = [ '#F7464A', '#46BFBD', '#FDB45C', '#487BB5' ]
    return colors[(id - 1) % colors.length]
  end

  def highlight
    colors = [ '#FF5A5E', '#5AD3D1', '#FFC870', '#5b8abd' ]
    return colors[(self.id - 1) % colors.length]
  end

end
