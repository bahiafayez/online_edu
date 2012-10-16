# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :course do
    short_name "MyString"
    name "MyString"
    start_date "2012-10-15"
    duration 1
    description "MyText"
    prerequisites "MyText"
    user_id 1
  end
end
