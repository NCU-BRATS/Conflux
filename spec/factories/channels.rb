FactoryGirl.define do
  factory :channel do
    sequence(:name)  { |n| Faker::Lorem.word + "#{n}" }
    description  { Faker::Lorem.sentence }
    announcement { Faker::Lorem.sentence }

    to_create { |channel| channel.save(validate: false) }
  end
end
