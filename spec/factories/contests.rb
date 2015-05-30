FactoryGirl.define do
  factory :contest do
    starts_at DateTime.now - 1.day
    finishes_at DateTime.now + 7.days

    stuffs { |a| [a.association(:stuff), a.association(:stuff)] }
  end

end
