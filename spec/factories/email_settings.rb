FactoryGirl.define do
  factory :email_settings, :class => 'EmailSettings' do
    new_follower true
    facebook_friend_sign_up true
    user
  end
end
