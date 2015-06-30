FactoryGirl.define do
  factory :project do
    sequence(:name)  { |n| Faker::Lorem.word + "#{n}" }

    to_create { |project| project.save(validate: false) }
  end
end
