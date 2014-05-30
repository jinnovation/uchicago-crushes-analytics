# TODO: cache results, only perform API search every x hours

require 'koala'

OAUTH_ACCESS_TOKEN = "CAACEdEose0cBAHk3AdUBdkevvS0x6e1tAtaIt5S2SjSvDdkeMEYzOup9XfM9VfS1howaKfniE1KJZA3VwfYI5lbbobrOTZBWcZBZA2bAlfzsxQMEA8bKzBck9nF3wnYDByT60t2LPZAu9AXSHPx8gf5jWkcoSZBx48toPFaz1d75O0WkMZCq8xvHZC911oc4BBgcSByo9zXR4wZDZD"

PAGE_NAME = "UChicagoCrushes"
NUM_SEARCH = 10

@graph = Koala::Facebook::API.new(OAUTH_ACCESS_TOKEN)

counts = Hash.new(0)

posts = @graph.get_connections(PAGE_NAME, "posts",
                               "limit" => NUM_SEARCH.to_s)

posts_withcomments = posts.find_all do |post|
  not post["comments"].nil?
end

puts posts_withcomments.size

posts_withcomments.each do |post|

  comments_withtags = post["comments"]["data"].find_all do |comment|
    not comment["message_tags"].nil?
  end
  
  comments_withtags.each do |comment|
    # TODO: filter out repeat tags in same post
    
    user_tags = comment["message_tags"].find_all { |tag| tag["type"]=="user" }

    user_tags.each do |tag|
      # TODO: check if first_name mentioned in comment body
      
      name = @graph.get_object(tag["id"])["name"]
      counts[name] += 1
    end
  end
end

# puts posts.next_page_params
