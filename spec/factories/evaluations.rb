# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :evaluation do
    user_id 1
    course_id 1
    group_id 1
    lecture_id 1
    evaluation "MyText"
  end
end
