FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| Faker::Internet.user_name + "#{n}" }
    email { Faker::Internet.email }

    to_create { |user| user.save(validate: false) }
  end
end
