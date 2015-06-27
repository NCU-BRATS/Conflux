FactoryGirl.define do
  factory :polling_option do
    title { Faker::Lorem.sentence }

    to_create { |option| option.save(validate: false) }
  end
end
