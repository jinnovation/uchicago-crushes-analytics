FactoryGirl.define do
  factory :post do

    # TODO: make inherited "named_post" to give content w/ name
    content         { Faker::Lorem.paragraph 4 }
    fb_created_time { Time.now }
    fb_id           { Faker::Number.number 10 }
  end
end
