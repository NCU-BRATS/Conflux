FactoryGirl.define do
  factory :attachment do
    name { Faker::Lorem.sentence }

    to_create { |attachment| attachment.save(validate: false) }
  end
end
