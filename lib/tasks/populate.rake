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
  task populate_fb: :environment do
    fb_posts_all = @graph.get_connections PAGE_NAME, "posts",
                                       "limit" => NUM_SEARCH.to_s

    fb_posts_all.each do |fb_post|
      msg = fb_post["message"]
      time = DateTime.iso8601 fb_post["created_time"]
      
      # TODO: might need check if post already exists in db
      post_curr = Post.create!(content: msg, fb_created_time: time)

      if not fb_post[TAG_COMMENTS].nil? # fb post has comments
        fb_post_cmts = fb_post[TAG_COMMENTS][TAG_DATA]

        fb_post_cmts_with_tags = fb_post_cmts.find_all do |cmt|
          not cmt[TAG_MSG_TAGS].nil?
        end

        fb_post_cmts_with_user_tags = fb_post_cmts_with_tags.find_all do |cmt|
          cmt[TAG_MSG_TAGS].each do |tag|
            tag[TAG_TYPE]==TAG_USER
          end
        end

        fb_post_cmts_with_user_tags.each do |cmt|
          cmt[TAG_MSG_TAGS].each do |tag|
            tagged_user_id = tag[TAG_ID]


            if (tagged_user = User.find_by_fb_id(tagged_user_id)).nil?
              # user not yet exist in db
              puts "User #{tagged_user_id}: NOT FOUND"
              tagged_user_data = @graph.get_object tagged_user_id
              
              tagged_user = user_fb_create! tagged_user_data
              puts "User #{tagged_user_id}: CREATED"

              crush_new = Crush.create!({ user_id: tagged_user.id,
                                          post_id: post_curr.id,
                                          num_tags: 1 })
              puts "Crush created: user #{crush_new.user_id} and post #{crush_new.post_id}"
            else
              puts "User #{tagged_user_id}: FOUND; name #{tagged_user.name}"


              crush_curr = Crush.where(user_id: tagged_user.id).where(post_id: post_curr.id)
              if crush_curr.nil?
                # no current association between post and user
                puts "No Crush between user #{tagged_user.id} and post #{post_curr.id}"
                crush_curr = Crush.create!({ user_id: tagged_user.id,
                                             post_id: post_curr.id,
                                             num_tags: 1 })
              else
                puts "Found Crush between user #{tagged_user.id} and post #{post_curr.id}"

                if crush_curr.first.nil?
                  puts "ERROR"
                else
                  crush_curr.first.num_tags += 1                  
                end
              end
            end


            
          end
        end
      else
        puts "Post: targetless"
      end      
    end
  end

  def user_fb_create!(fb_data)
    User.create!(name: fb_data[TAG_NAME_FULL],
                 fb_id: fb_data["id"],
                 pic_url_small: @graph.get_picture(fb_data["id"],
                                                   width: "50",
                                                   height: "50"),
                 pic_url_medium: @graph.get_picture(fb_data["id"],
                                                    width: "100",
                                                    height:"100"),
                 pic_url_large: @graph.get_picture(fb_data["id"],
                                                   width: "200",
                                                   height: "200"),
                 profile_url: fb_data[TAG_PROFILE_LINK])
  end

  def get_posts_with_comments(posts)
    puts "NUMBER OF POSTS FETCHED = #{posts.size}"

    posts_with_comments = posts.find_all { |post| not post[TAG_COMMENTS].nil? }
    puts "NUMBER OF POSTS WITH COMMENTS = #{posts_with_comments.size}"

    return posts_with_comments
  end
end
