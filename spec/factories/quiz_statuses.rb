# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :quiz_status do
    user_id 1
    quiz_id 1
    course_id 1
    status "MyString"
  end
end
