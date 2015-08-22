FactoryGirl.define do
  factory :sprint do
    title { Faker::Lorem.sentence }
    statuses { [ { id: 1, name: 'backlog' }, { id: 2, name: 'done' } ] }

    to_create { |sprint| sprint.save(validate: false) }
  end
end
