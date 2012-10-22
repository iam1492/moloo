# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :subcomment do
    content "MyString"
    comment_id 1
  end
end
