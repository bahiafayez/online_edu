# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :quiz do
    course_id 1
    name "MyString"
    instructions "MyString"
  end
end
