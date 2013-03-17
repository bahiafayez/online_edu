# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :document do
    name "MyString"
    url "MyString"
    group_id 1
    course_id 1
  end
end
