FactoryGirl.define do
  factory :crush do
    association :user
    association :post
    num_tags      { 1 + Random.rand(10) }
    quotient      0.0
    last_tag_time { DateTime.now }
  end
end
