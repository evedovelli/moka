class Identity < ActiveRecord::Base
  belongs_to :user
  attr_accessible :provider, :uid

  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider

  def self.find_for_oauth(auth)
    return Identity.where(uid: auth.uid, provider: auth.provider).first_or_create
  end

  def self.search_friend(uid, provider)
    identity = Identity.where(uid: uid, provider: provider).first
    if identity
      return identity.user
    else
      return nil
    end
  end
end
