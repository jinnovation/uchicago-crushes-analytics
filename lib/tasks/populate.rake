# TODO
# - only pull results that are new from last pull time
#   - save last pull time

namespace :db do
  desc "Erase database and fill with sample data"
  task populate: :environment do
    Rake::Task["db:reset"].invoke

    User.populate 10 do |user|
      user.name = Faker::Name.name

      Crush.populate 5..10 do |crush|
        crush.content = Faker::Lorem.sentences(10..13)
        crush.user_id = user.id
      end
    end
  end
  
  desc "Pull data from Facebook and use to populate database"
  task update: :environment do
    TAG_COMMENTS  = "comments"
    TAG_DATA      = "data"
    TAG_MSG_TAGS  = "message_tags"
    TAG_TYPE      = "type"
    TAG_USER      = "user"
    TAG_ID        = "id"
    TAG_NAME_FULL = "name"

    @oauth = Koala::Facebook::OAuth.new(ENV["FB_APP_ID"], ENV["FB_APP_SECRET"])
    @token = @oauth.get_app_access_token
    @graph = Koala::Facebook::API.new(@token, ENV["FB_APP_SECRET"])

    posts = @graph.get_connections(PAGE_NAME, "posts",
                                   "limit" => NUM_SEARCH.to_s)
    puts "NUMBER OF POSTS FETCHED = #{posts.size}"

    posts_withcmts = posts.find_all { |post| not post[TAG_COMMENTS].nil? }
    puts "NUMBER OF POSTS WITH COMMENTS = #{posts_withcmts.size}"

    all_user_tag_ids = []
    counts           = Hash.new(0)

    posts_withcmts.each do |post|
      msg = post["message"]

      cmts_with_user_tags = post[TAG_COMMENTS][TAG_DATA].find_all do |cmt|
        not cmt[TAG_MSG_TAGS].nil?
      end

      cmts_with_user_tags = cmts_with_user_tags.each do |cmt|
        cmt[TAG_MSG_TAGS].find_all { |tag| tag[TAG_TYPE]==TAG_USER }
      end

      cmts_with_user_tags.each do |cmt|
        user_tags = cmt[TAG_MSG_TAGS].find_all { |tag|
          tag[TAG_TYPE]==TAG_USER }

        # TODO:
        # if msg.contains(tag[first_name]) or !user_tags.contains(tag)
        #   add to user_tags
        # else
        #   continue

        user_tags.each { |tag| all_user_tag_ids.push tag[TAG_ID] }
      end
    end

    users = (@graph.get_objects all_user_tag_ids).values
    puts "NUMBER OF TAGGED USERS = #{users.size}"

    users.each { |user| counts[user[TAG_NAME_FULL]] += 1 }

    counts.each { |name,count| puts "#{name.to_s}: #{count.to_s}" }
  end
end
