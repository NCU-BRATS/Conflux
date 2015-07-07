FactoryGirl.define do
  factory :snippet do
    name { Faker::Lorem.sentence }
    content { Faker::Lorem.sentence }
    language { Snippet::LANGUAGES.to_a.sample(1)[0][0] }

    to_create { |snippet| snippet.save(validate: false) }
  end
end
