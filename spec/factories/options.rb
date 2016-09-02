include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :option do
    name "Potato"
    picture_file_name 'chips.png'
    picture_content_type 'image/png'
    picture_file_size 4.kilobytes
    picture_updated_at DateTime.now

    transient do
      number_of_votes 0
      number_of_comments 0
    end

    after :build do |option, evaluator|
      option.votes.push FactoryGirl.build_list(:vote, evaluator.number_of_votes, option: nil)
      option.comments.push FactoryGirl.build_list(:comment, evaluator.number_of_comments, option: nil)
    end
  end
end
