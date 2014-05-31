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
  
  desc "Erase database, pull data from Facebook and use to populate database"
  task populate_fb: [:environment] do
    
    posts = @graph.get_connections(PAGE_NAME, "posts",
                                   "limit" => NUM_SEARCH.to_s)
    puts "NUMBER OF POSTS FETCHED = #{posts.size}"

    posts_withcmts = posts.find_all { |post| not post[TAG_COMMENTS].nil? }
    puts "NUMBER OF POSTS WITH COMMENTS = #{posts_withcmts.size}"

    all_user_tag_ids = []
    counts           = Hash.new(0)

    usr_msgs = Hash.new { |h,k| h[k] = [] }

    posts_withcmts.each do |post|
      msg = post["message"]

      cmts_with_user_tags = post[TAG_COMMENTS][TAG_DATA].find_all do |cmt|
        not cmt[TAG_MSG_TAGS].nil?
      end

      cmts_with_user_tags = cmts_with_user_tags.each do |cmt|
        cmt[TAG_MSG_TAGS].find_all { |tag| tag[TAG_TYPE]==TAG_USER }
      end

      cmts_with_user_tags.each do |cmt|

        cmt[TAG_MSG_TAGS].each do |tag|
          # TODO:
          # if tag is a double tag:
          #   break; move on to next comment
          # else if msg does not contain tag[first_name]:
          #   ignore; move to next tag
          # else:

          # TODO: add post_url to each crush
          usr_msgs[tag[TAG_ID]].push msg
        end
      end
    end

    users = (@graph.get_objects usr_msgs.keys)
    puts "NUMBER OF TAGGED USERS = #{users.size}"
    
    usr_msgs.each do |id, msgs|

      if users[id].nil?
        # FIXME: wtf is causing these??
        
        puts "ERROR"        
      else
        # TODO:
        # If user exists already, simply add to that
        
        puts users[id][TAG_NAME_FULL]
        user = User.create(name: users[id][TAG_NAME_FULL],
                           pic_url: @graph.get_picture(id),
                           profile_url: users[id][TAG_PROFILE_LINK])

        msgs.each do |msg|
          Crush.create(content: msg,
                       user_id: user.id)
        end
      end

    end
  end
end
