FactoryGirl.define do
  factory :facebook_friendship do
    after :build do |facebook_friendship, evaluator|
      facebook_friendship.user ||= FactoryGirl.build(:user, username: "user", email: "user@user.com")
      facebook_friendship.facebook_friend ||= FactoryGirl.build(:user, username: "friend", email: "friend@friend.com")
    end
  end
end
