FactoryGirl.define do
  factory :post do
    name { Faker::Lorem.sentence }
    content { Faker::Lorem.sentence }

    to_create { |post| post.save(validate: false) }
  end
end
