FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| Faker::Lorem.word + "#{n}" }
    email { Faker::Internet.email }

    to_create { |user| user.save(validate: false) }
  end
end
