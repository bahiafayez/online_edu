# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :lecture_question do
    user_id 1
    course_id 1
    lecture_id 1
    time 1.5
    question "MyText"
  end
end
