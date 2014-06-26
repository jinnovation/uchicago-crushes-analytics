FactoryGirl.define do
  factory :crush do
    user_id       { Random.rand 100 }
    post_id       { Random.rand 100 }
    num_tags      { 1 + Random.rand(10) }
    quotient      0.0
    last_tag_time { DateTime.now }
  end
end
