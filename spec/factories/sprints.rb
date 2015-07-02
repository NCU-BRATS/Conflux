FactoryGirl.define do
  factory :sprint do
    title { Faker::Lorem.sentence }

    to_create { |sprint| sprint.save(validate: false) }
  end
end
