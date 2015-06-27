FactoryGirl.define do
  factory :user do
    name  { Faker::Name.name }
    email { Faker::Internet.email }

    to_create { |user| user.save(validate: false) }
  end
end
