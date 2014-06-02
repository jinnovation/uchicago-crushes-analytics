# TODO
# - only pull results that are new from last pull time
#   - save last pull time

namespace :db do
  desc "Erase database and fill with sample data"
  task populate: :environment do
    Rake::Task["db:reset"].invoke

    User.populate 10 do |user|
      user.name = Faker::Name.name

      Post.populate 5..10 do |post|
        post.content = Faker::Lorem.sentences(10..13)
        post.user_id = user.id
      end
    end
  end

  desc "Erase database, pull data from Facebook and use to populate database"
  task populate_fb: [:environment] do

    posts = get_posts_with_comments()

    usr_msgs = Hash.new { |h,k| h[k] = [] }

    posts.each do |post|
      msg = post["message"]

      comments_with_user_tags = post[TAG_COMMENTS][TAG_DATA].find_all do |cmt|
        not cmt[TAG_MSG_TAGS].nil?
      end

      comments_with_user_tags.each do |cmt|
        cmt[TAG_MSG_TAGS].each do |tag|
          next if not tag[TAG_TYPE]==TAG_USER

          # TODO: add post_url to each post
          usr_msgs[tag[TAG_ID]].push msg
        end
      end
    end

    user_info = (@graph.get_objects usr_msgs.keys)
    puts "NUMBER OF TAGGED USERS = #{user_info.size}"

    usr_msgs.each do |id, msgs|
      user_full_name = user_info[id][TAG_NAME_FULL]

      if (user = User.find_by_name user_full_name).nil?
        puts "Creating User #{user_info[id][TAG_NAME_FULL]}"

        user = User.create!(name: user_info[id][TAG_NAME_FULL],
                            pic_url_small: @graph.get_picture(id, width: "50",
                                                              height: "50"),
                            pic_url_medium: @graph.get_picture(id, width: "100",
                                                               height: "100"),
                            pic_url_large: @graph.get_picture(id, width: "200",
                                                              height: "200"),
                            profile_url: user_info[id][TAG_PROFILE_LINK])
      else
        puts "Found User #{user.name}"
      end

      msgs.each do |msg|
        # TODO:
        # provide "probability" for each post-user pair
        # (based on: num mentions, first and last name in msg, etc.)

        # TODO: make each post associable with multiple users
        # if not Post.exists?(content: msg)
        #   Post.create content: msg, user_id: user.id
        # end

        Post.create content: msg, user_id: user.id
      end
    end
  end

  def get_posts_with_comments()
    posts = @graph.get_connections PAGE_NAME, "posts", "limit" => NUM_SEARCH.to_s
    puts "NUMBER OF POSTS FETCHED = #{posts.size}"

    posts_with_comments = posts.find_all { |post| not post[TAG_COMMENTS].nil? }
    puts "NUMBER OF POSTS WITH COMMENTS = #{posts_with_comments.size}"

    posts_with_comments
  end
end
