FactoryGirl.define do
  factory :label do
    title { Faker::Lorem.word }
    color { '#' + '%06x' % (rand * 0xffffff) }

    to_create { |label| label.save(validate: false) }
  end
end
