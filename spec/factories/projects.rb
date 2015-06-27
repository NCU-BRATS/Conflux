FactoryGirl.define do
  factory :project do
    name  { Faker::Name.name }

    to_create { |project| project.save(validate: false) }
  end
end
