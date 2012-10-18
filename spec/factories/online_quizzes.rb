# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :online_quiz do
    lecture_id 1
    question "MyText"
    time 1.5
  end
end
