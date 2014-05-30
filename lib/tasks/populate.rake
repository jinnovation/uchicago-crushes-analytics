# TODO
# - only pull results that are new from last pull time
#   - save last pull time

namespace :db do
  desc "Erase and fill database"

  TAG_COMMENTS  = "comments"
  TAG_DATA      = "data"
  TAG_MSG_TAGS  = "message_tags"
  TAG_TYPE      = "type"
  TAG_USER      = "user"
  TAG_ID        = "id"
  TAG_NAME_FULL = "name"

  task populate: :environment do
    # TODO: cache results, only perform API search every x hours
    require 'koala'

    counts = Hash.new(0)
    APP_ID = ENV["FB_APP_ID"]
    APP_SECRET = ENV["FB_APP_SECRET"]

    @oauth = Koala::Facebook::OAuth.new(APP_ID, APP_SECRET)
    @token = @oauth.get_app_access_token
    @graph = Koala::Facebook::API.new(@token, APP_SECRET)

    posts = @graph.get_connections(PAGE_NAME, "posts",
                                   "limit" => NUM_SEARCH.to_s)
    posts_withcomments = posts.find_all do |post|
      not post[TAG_COMMENTS].nil?
    end

    puts posts_withcomments.size

    posts_withcomments.each do |post|

      comments_withtags = post[TAG_COMMENTS][TAG_DATA].find_all do |comment|
        not comment[TAG_MSG_TAGS].nil?
      end
      
      comments_withtags.each do |comment|
        # TODO: filter out repeat tags in same post
        
        user_tags = comment[TAG_MSG_TAGS].find_all { |tag| tag[TAG_TYPE]==TAG_USER }

        user_tags.each do |tag|
          # TODO: check if first_name mentioned in comment body
          
          name = @graph.get_object(tag[TAG_ID])[TAG_NAME_FULL]
          counts[name] += 1
        end
      end
    end

    counts.each do |name,count|
      puts "#{name.to_s}: #{count.to_s}"
    end

  end  
end
