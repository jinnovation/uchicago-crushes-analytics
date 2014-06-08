FactoryGirl.define do
  factory :user do
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    profile_url Faker::Internet.url("facebook.com")
    pic_url_small Faker::Internet.url("facebook.com")
    pic_url_medium Faker::Internet.url("facebook.com")
    pic_url_large Faker::Internet.url("facebook.com")
    fb_id Faker::Number.number(10)
  end

  factory :crush do
  end

  factory :post do
    content         Faker::Lorem.paragraph(4)
    fb_created_time Time.now
    fb_id           Faker::Number.number(10)
  end
end
