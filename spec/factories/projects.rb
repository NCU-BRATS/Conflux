FactoryGirl.define do
  factory :project do
    sequence(:name)  { |n| Faker::Internet.user_name + "#{n}" }

    to_create { |project| project.save(validate: false) }
  end
end
