FactoryGirl.define do
  factory :option do
    picture "1"
    name "Adriana"

    transient do
      number_of_votes 0
    end

    after :build do |option, evaluator|
      option.votes.push FactoryGirl.build_list(:vote, evaluator.number_of_votes, option: nil)
    end
  end
end
