FactoryGirl.define do
  factory :comment do
    body "A truly comment"
    user
    option

    after :build do |comment|
      comment.user ||= FactoryGirl.build(:user)
      comment.option ||= FactoryGirl.build(:option)
    end
  end
end
