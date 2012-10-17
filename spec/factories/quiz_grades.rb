# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :quiz_grade do
    user_id 1
    quiz_id 1
    question_id 1
    answer_id 1
    grade 1.5
  end
end
