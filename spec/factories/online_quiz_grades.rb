# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :online_quiz_grade do
    user_id 1
    online_quiz_id 1
    online_answer_id 1
    grade 1.5
  end
end
