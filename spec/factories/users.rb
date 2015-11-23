FactoryGirl.define do
  factory :user do
    email 'example@example.com'
    username 'tester'
    password 'changeme'
    password_confirmation 'changeme'

    after(:create) { |user| user.confirm }
  end
end
