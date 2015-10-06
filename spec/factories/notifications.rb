FactoryGirl.define do
  factory :notification do
    type "vote_notification"

    after :build do |notification|
      notification.user ||= FactoryGirl.build(:user)
      notification.sender ||= FactoryGirl.build(:user)
    end
  end
end
