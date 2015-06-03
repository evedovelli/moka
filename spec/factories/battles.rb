FactoryGirl.define do
  factory :battle do
    starts_at DateTime.now - 1.day
    finishes_at DateTime.now + 7.days

    options { |a| [a.association(:option), a.association(:option)] }
  end

end
