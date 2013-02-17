# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :free_answer do
    user_id 1
    quiz_id 1
    question_id 1
    answer "MyText"
  end
end
