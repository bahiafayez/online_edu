# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :pause do
    lecture_id 1
    course_id 1
    user_id 1
    time 1.5
  end
end
