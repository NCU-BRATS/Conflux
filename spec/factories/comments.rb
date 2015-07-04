FactoryGirl.define do
  factory :comment do
    content { Faker::Lorem.sentence }

    to_create { |comment| comment.save(validate: false) }
  end
end
