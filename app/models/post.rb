class Post < ActiveRecord::Base
  TIME_DISP_FMT   = "%B %d, %Y %l:%M %p"

  has_many :crushes
  has_many :users, through: :crushes

  validates :content, 
    {
     presence: true,
     allow_blank: false,
    }

  validates :fb_created_time,
    {
     presence: true,
     allow_blank: false,
    }

  validates :fb_id,
    {
     presence: true,
     allow_blank: false,
    }

  validate :crush_quotient_sum_valid?

  def self.latest(count=1)
    posts_sorted_time = self.all.sort_by(&:fb_created_time).reverse

    if count == 1
      posts_sorted_time.first
    else
      posts_sorted_time.first count
    end
  end

  def crush_quotient_sum_valid?
    return if self.crushes.count == 0

    if (1.0 - self.crushes.map(&:quotient).sum).abs >= 0.05
      errors.add :posts, "Post.crushes.quotient.sum must ~= 1.0"
    end
  end

  def total_tag_count
    self.crushes.inject(0) do |sum,crush|
      sum += crush.num_tags
    end
  end

  # TODO: validate that 1.0 - (sum of all crush quotients) < 0.2 (or other val)

  def fb_url
    FB_URL_BASE + self.fb_id
  end

  def time_display
    self.fb_created_time.strftime TIME_DISP_FMT
  end

  def user_with_highest_score
    crush_highest = self.crushes.sort_by {|crush| crush.quotient}.reverse.first

    if crush_highest.nil? then nil else crush_highest.user end
  end

  def user_mentioned_name_full?(user)    
    self.content.downcase.include? user.full_name.split.map(&:downcase).join(' ')
  end

  def user_mentioned_name_first?(user)
    self.content.downcase.include? user.first_name.downcase
  end

  def user_mentioned_name_last?(user)
    self.content.downcase.include? user.last_name.downcase
  end

  def users_mentioned_by_name_full
    self.users.find_all do |user|
      user_mentioned_name_full? user
    end
  end

  def users_mentioned_by_name_first
    self.users.find_all do |user|
      user_mentioned_name_first? user
    end    
  end

  def users_mentioned_by_name_last
    self.users.find_all do |user|
      user_mentioned_name_last? user
    end
  end

  def quotients_set_all(users, val)
    users.each do |user|
      crush_curr = Crush.find_by_user_id_and_post_id user.id, self.id

      crush_curr.update_attributes quotient: val
    end    
  end

  def quotients_calc_from_num_tags(users)
    users_tags_total = users.inject(0) do |sum,user|
      sum += Crush.find_by_user_id_and_post_id(user.id, self.id).num_tags
    end
    
    users.each do |user|
      crush_curr = Crush.find_by_user_id_and_post_id(user.id, self.id)

      quotient_new = (crush_curr.num_tags.to_f / users_tags_total.to_f).round 2

      crush_curr.update_attributes quotient: quotient_new
    end
  end

  def quotients_calc
    # FIXME: what if post contains substring of {first,last,full} name
    # FIXME: account for multiple {first,last,full} name in Post.contents

    if users_mentioned_by_name_full.any?
      primary_user_base = users_mentioned_by_name_full
    elsif users_mentioned_by_name_first.any?
      primary_user_base = users_mentioned_by_name_first
    elsif users_mentioned_by_name_last.any?
      primary_user_base = users_mentioned_by_name_last
    else
      primary_user_base = []
    end

    every_other_user = self.users.select do |user|
      not primary_user_base.include?(user)
    end

    if primary_user_base.any?
      quotients_calc_from_num_tags primary_user_base

      quotients_set_all every_other_user, 0.0
    else
      quotients_calc_from_num_tags every_other_user      
    end
  end

end
