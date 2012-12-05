# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :announcement do
    announcement "MyText"
    date "2012-12-04 21:13:00"
    course_id 1
    user_id 1
  end
end
