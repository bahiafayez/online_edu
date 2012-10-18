# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :online_answer do
    online_quiz_id 1
    answer "MyText"
    xcoor 1.5
    ycoor 1.5
  end
end
