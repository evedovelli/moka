FactoryGirl.define do
  factory :vote do
    option nil
    battle nil

    after :build do |vote|
      vote.battle ||= FactoryGirl.build(:battle)
      vote.option ||= vote.battle.options[0]
    end
  end

end
