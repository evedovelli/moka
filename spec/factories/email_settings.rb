FactoryGirl.define do
  factory :email_settings, :class => 'EmailSettings' do
    new_follower true
    user
  end
end
