# TODO
# - only pull results that are new from last pull time
#   - save last pull time
# - periodically refresh/replace user profile pic URLs

require 'facebook_post'

namespace :db do

  desc "Erase database, pull data from Facebook and use to populate database"
  task populate_fb: :environment do
    fb_posts_all = @graph.get_connections PAGE_NAME, "posts",
                                       "limit" => NUM_SEARCH.to_s
    puts "NUMBER OF POSTS FETCHED = #{fb_posts_all.size}"

    fb_posts_with_msgs = fb_posts_all.find_all { |post| not post[TAG_MSG].nil? }
    puts "NUMBER OF POSTS WITH MESSAGES = #{fb_posts_with_msgs.size}"

    fb_posts_with_msgs.each do |fb_post|
      fb_post_process fb_post
    end
  end

  # TODO: make FacebookPost class, stick all these methods in there
  def fb_post_has_no_commments(fb_post)
    fb_post[TAG_COMMENTS].nil?
  end

  def fb_post_process(fb_post)
    # TODO: need way to update previously-untagged posts with tags
    
    post_curr = post_fb_create! fb_post

    if fb_post_has_no_commments fb_post
      puts "Post: targetless"
      next
    end
    
    fb_post_cmts_with_tags = fb_post[TAG_COMMENTS][TAG_DATA].find_all do |cmt|
      not cmt[TAG_MSG_TAGS].nil?
    end

    fb_post_cmts_with_tags.each do |cmt|
      # TODO: move this into filter cond for fb_post_cmts_with_tags
      next if cmt[TAG_MSG_TAGS].any? { |tag| tag[TAG_TYPE]!=TAG_USER }

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
          puts "User #{tagged_user_id}: FOUND; name #{tagged_user.full_name}"

          crush_curr = Crush.where(user_id: tagged_user.id, post_id: post_curr.id)
          if crush_curr.empty?
            # no current association between post and user
            puts "No Crush between user #{tagged_user.id} and post #{post_curr.id}"
            crush_curr = Crush.create!({ user_id: tagged_user.id,
                                         post_id: post_curr.id,
                                         num_tags: 1 })
          else
            puts "Found Crush between user #{tagged_user.id} and post #{post_curr.id}"
            crush_curr.first.num_tags += 1                  
          end
        end            
      end
    end
  end

  def user_fb_create!(fb_data)
    User.create!(first_name: fb_data[TAG_FIRST_NAME],
                 last_name: fb_data[TAG_LAST_NAME],
                 fb_id: fb_data[TAG_ID],
                 pic_url_small: @graph.get_picture(fb_data[TAG_ID],
                                                   width: IMG_DIM_S_W,
                                                   height: IMG_DIM_S_H),
                 pic_url_medium: @graph.get_picture(fb_data[TAG_ID],
                                                    width: IMG_SIM_M_W,
                                                    height: IMG_SIM_M_H),
                 pic_url_large: @graph.get_picture(fb_data[TAG_ID],
                                                   width: IMG_DIM_L_W,
                                                   height: IMG_DIM_L_H),
                 profile_url: fb_data[TAG_PROFILE_LINK])
  end

  def get_posts_with_comments(posts)
    puts "NUMBER OF POSTS FETCHED = #{posts.size}"

    posts_with_comments = posts.find_all { |post| not post[TAG_COMMENTS].nil? }
    puts "NUMBER OF POSTS WITH COMMENTS = #{posts_with_comments.size}"

    return posts_with_comments
  end

  def post_fb_create!(fb_data)
    Post.create!({ content: fb_data[TAG_MSG],
                   fb_created_time: DateTime.iso8601(fb_data[TAG_TIME]),
                   fb_id: fb_data[TAG_ID] })
  end
end
