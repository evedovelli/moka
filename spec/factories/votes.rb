FactoryGirl.define do
  factory :vote do
    stuff nil
    contest nil

    after :build do |vote|
      vote.contest ||= FactoryGirl.build(:contest)
      vote.stuff ||= vote.contest.stuffs[0]
    end
  end

end
