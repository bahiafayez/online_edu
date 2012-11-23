# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :lecture_view do
    user_id 1
    lecture_id 1
    course_id 1
  end
end
