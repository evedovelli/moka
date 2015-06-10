class Option < ActiveRecord::Base
  resourcify

  belongs_to :battle
  has_many :votes, dependent: :destroy

  attr_accessible :name, :picture

  validates :name,    :presence => true
  validates :picture, :presence => true,
                      :numericality => { :only_integer => true,
                                         :greater_than_or_equal_to => 1,
                                         :less_than_or_equal_to => 4 }

  def color
    colors = [ '#F7464A', '#46BFBD', '#FDB45C', '#487BB5' ]
    return colors[(self.picture - 1) % colors.length]
  end

  def highlight
    colors = [ '#FF5A5E', '#5AD3D1', '#FFC870', '#5b8abd' ]
    return colors[(self.picture - 1) % colors.length]
  end

end
