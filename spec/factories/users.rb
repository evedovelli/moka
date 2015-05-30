FactoryGirl.define do
  factory :user do
    email 'example@example.com'
    username 'tester'
    password 'changeme'
    password_confirmation 'changeme'
    # required if the Devise Confirmable module is used
    # confirmed_at Time.now
  end
end
