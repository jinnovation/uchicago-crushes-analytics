FactoryGirl.define do
  factory :user do
    first_name     { Faker::Name.first_name }
    last_name      { Faker::Name.last_name }
    
    profile_url    { Faker::Internet.url("facebook.com") }
    sequence(:pic_url_small) { |n| Faker::Internet.url("facebook.com")+n.to_s }
    sequence(:pic_url_medium) { |n| Faker::Internet.url("facebook.com")+n.to_s }
    sequence(:pic_url_large) { |n| Faker::Internet.url("facebook.com")+n.to_s }
    fb_id          { Faker::Number.number 10 }
  end
end
