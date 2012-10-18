# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :lecture do
    course_id 1
    name "MyString"
    description "MyText"
    url "MyString"
  end
end
