FactoryGirl.define do
  factory :battle do
    starts_at DateTime.now - 1.day
    finishes_at DateTime.now + 7.days

    transient do
      number_of_options 2
    end

    after :build do |battle, evaluator|
      battle.options.push FactoryGirl.build_list(:option, evaluator.number_of_options, battle: nil)
    end
  end
end
