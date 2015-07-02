FactoryGirl.define do
  factory :issue do
    title { Faker::Lorem.sentence }

    to_create { |issue| issue.save(validate: false) }
  end
end
