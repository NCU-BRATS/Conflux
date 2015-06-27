FactoryGirl.define do
  factory :poll do
    title { Faker::Lorem.sentence }

    to_create { |poll| poll.save(validate: false) }
  end
end
