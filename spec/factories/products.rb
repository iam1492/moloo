# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product do
    name "MyString"
    description "MyString"
    price ""
    handed 1
    user_id 1
  end
end
