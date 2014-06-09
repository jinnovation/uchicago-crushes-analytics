# TODO
# - only pull results that are new from last pull time
#   - save last pull time
# - periodically refresh/replace user profile pic URLs

namespace :db do

  require 'facebook_post'

  # Koala's next_page method seems to have a bug involving the version prefix in
  # next_page_params.base; this "fixes" that
  def my_next_page(pull)
    base, args = pull.next_page_params
    base.slice! "v2.0/"
    @graph.get_page([base, args])
  end

  task pull_fb: :environment do
    pull = @graph.get_connections PAGE_NAME, "posts",
      "limit" => NUM_SEARCH.to_s

    total = pull.length

    while (pull_next = my_next_page(pull))!=[]
      puts total += pull_next.length
    end
  end

  desc "Erase database, pull data from Facebook and use to populate database"
  task populate_fb: :environment do
    fb_posts_all = @graph.get_connections PAGE_NAME, "posts",
                                       "limit" => NUM_SEARCH.to_s
    puts "NUMBER OF POSTS FETCHED = #{fb_posts_all.size}" if verbose == true

    process_batch(fb_posts_all)
  end

  def process_batch(fb_posts)
    fb_posts_with_msgs = fb_posts.find_all do |post|
      not post[FacebookPost::TAG_MSG].nil?
    end

    puts "NUMBER OF POSTS WITH MESSAGES ="\
      " #{fb_posts_with_msgs.size}" if verbose == true

    fb_posts_with_msgs.each do |fb_post|
      # TODO: need way to update previously-untagged posts with tags

      post_curr = post_fb_create! fb_post unless post_curr = Post.find_by_fb_id(fb_post[FacebookPost::TAG_ID])

      puts "Current post pre-exist = #{post_curr.new_record?}" if verbose == true

      # still want comment-less posts on record, for viewing pleasure
      next if fb_post[FacebookPost::TAG_COMMENTS].nil?

      fb_post_cmts = fb_post[FacebookPost::TAG_COMMENTS][FacebookPost::TAG_DATA]

      fb_post_cmts_with_tags = fb_post_cmts.find_all do |cmt|
        not cmt[FacebookPost::TAG_MSG_TAGS].nil?
      end

      fb_post_cmts_with_tags.each do |cmt|
        cmt_create_time = cmt[FacebookPost::TAG_CMT_CREATED_TIME]

        cmt[FacebookPost::TAG_MSG_TAGS].each do |tag|
          next if tag[FacebookPost::TAG_TYPE] != FacebookPost::TAG_USER

          tagged_user_id = tag[FacebookPost::TAG_ID]

          if (tagged_user = User.find_by_fb_id(tagged_user_id)).nil?
            # user not yet exist in db
            puts "User #{tagged_user_id}: NOT FOUND" if verbose == true

            begin
              tagged_user_data = @graph.get_object tagged_user_id
            rescue
              # FIXME: why the hell?
              puts "@graph.get_object tagged_user_id => EXCEPTION"
              next
            end

            tagged_user = user_fb_create! tagged_user_data
            puts "User #{tagged_user_id}: CREATED" if verbose == true

            crush_new = Crush.create!({ user_id: tagged_user.id,
                                       post_id: post_curr.id,
                                       num_tags: 1,
                                       quotient: 0.0,
                                       last_tag_time: cmt_create_time })

            puts "Crush created: user #{crush_new.user_id}"\
              " and post #{crush_new.post_id}" if verbose == true
          else
            puts "User #{tagged_user_id}: FOUND;"\
              " name #{tagged_user.full_name}" if verbose == true

            crush_curr = Crush.where(user_id: tagged_user.id, post_id: post_curr.id)
            if crush_curr.empty?
              # no current association between post and user
              puts "No Crush between user #{tagged_user.id}"\
                " and post #{post_curr.id}" if verbose == true

              crush_curr = Crush.create!({ user_id: tagged_user.id,
                                          post_id: post_curr.id,
                                          num_tags: 1,
                                          quotient: 0.0,
                                          last_tag_time: cmt_create_time })
            else
              puts "Found Crush between user #{tagged_user.id}"\
                " and post #{post_curr.id}" if verbose == true

              crush_curr.first.update_tag_time cmt_create_time
              crush_curr.first.num_tags += 1
            end
          end
        end
      end

      post_curr.quotients_calc
    end
  end

  def user_fb_create!(fb_data)
    url_small, url_medium, url_large = @graph.batch do |batch_api|
      batch_api.get_picture(fb_data[FacebookPost::TAG_ID],
                            width: IMG_DIM_S_W,
                            height: IMG_DIM_S_H)
      batch_api.get_picture(fb_data[FacebookPost::TAG_ID],
                            width: IMG_DIM_M_W,
                            height: IMG_DIM_M_H)
      batch_api.get_picture(fb_data[FacebookPost::TAG_ID],
                            width: IMG_DIM_L_W,
                            height: IMG_DIM_L_H)
    end


    User.create!(first_name: fb_data[FacebookPost::TAG_FIRST_NAME],
                 last_name: fb_data[FacebookPost::TAG_LAST_NAME],
                 fb_id: fb_data[FacebookPost::TAG_ID],
                 pic_url_small:  url_small,
                 pic_url_medium: url_medium,
                 pic_url_large:  url_large,
                 profile_url: fb_data[FacebookPost::TAG_PROFILE_LINK])
  end

  def post_fb_create!(fb_data)
    Post.create!(content: fb_data[FacebookPost::TAG_MSG],
                 fb_created_time: DateTime.iso8601(fb_data[FacebookPost::TAG_TIME]),
                 fb_id: fb_data[FacebookPost::TAG_ID])
  end
end
