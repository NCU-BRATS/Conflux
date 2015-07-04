FactoryGirl.define do
  factory :message do
    content { Faker::Lorem.sentence }

    to_create { |message| message.save(validate: false) }
  end
end
