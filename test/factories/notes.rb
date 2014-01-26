# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :note do
    name "MyString"
    description "MyText"
    content "MyText"
  end
end
