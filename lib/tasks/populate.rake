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
    Koala.config.api_version = 'v2.0'

    APP_ID = ENV["FB_APP_ID"]
    APP_SECRET = ENV["FB_APP_SECRET"]

    @oauth = Koala::Facebook::OAuth.new(APP_ID, APP_SECRET)
    @token = @oauth.get_app_access_token
    @graph = Koala::Facebook::API.new(@token, APP_SECRET)

    posts = @graph.get_connections(PAGE_NAME, "posts",
                                   "limit" => NUM_SEARCH.to_s)
    puts "NUMBER OF POSTS FETCHED = #{posts.size}"

    posts_withcmts = posts.find_all do |post|
      not post[TAG_COMMENTS].nil?
    end
    puts "NUMBER OF POSTS WITH COMMENTS = #{posts_withcmts.size}"

    all_user_tag_ids = []
    counts = Hash.new(0)

    posts_withcmts.each do |post|
      cmts_with_user_tags = post[TAG_COMMENTS][TAG_DATA].find_all do |cmt|
        not cmt[TAG_MSG_TAGS].nil?
      end

      cmts_with_user_tags = cmts_with_user_tags.each { |cmt|
      cmt[TAG_MSG_TAGS].find_all { |tag| tag[TAG_TYPE]==TAG_USER } }

      # TODO: tag_ids = extract out all tag IDs

      cmts_with_user_tags.each do |cmt|
        # TODO: filter out repeat tags in same post

        user_tags = cmt[TAG_MSG_TAGS].find_all { |tag|
          tag[TAG_TYPE]==TAG_USER }

        user_tags.each do |tag|

          all_user_tag_ids.push tag[TAG_ID]
          # puts @graph.get_object(tag[TAG_ID])[TAG_NAME_FULL]
          #   # TODO: check if first_name mentioned in comment body

          #   name = @graph.get_object(tag[TAG_ID])[TAG_NAME_FULL]
          # counts[name] += 1
        end
      end
    end

    users = (@graph.get_objects all_user_tag_ids).values
    user_names = []
    users.each do |user|
      user_names.push user[TAG_NAME_FULL]
    end
    puts "NUMBER OF TAGGED USERS = #{user_names.size}"

    user_names.each do |name|
      counts[name]+=1
    end

    counts.each do |name,count|
      puts "#{name.to_s}: #{count.to_s}"
    end

  end
end
