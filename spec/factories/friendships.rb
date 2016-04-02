FactoryGirl.define do
  factory :friendship do
    after :build do |friendship, evaluator|
      friendship.user ||= FactoryGirl.build(:user, username: "user", email: "user@user.com")
      friendship.friend ||= FactoryGirl.build(:user, username: "friend", email: "friend@friend.com")
    end
  end
end
