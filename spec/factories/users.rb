FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| Faker::Lorem.word + "#{n}" }
    email { Faker::Internet.email }
    password { Faker::Number.number(10) }

    to_create do |user|
      user.confirm
      user.save(validate: false)
    end
  end
end
