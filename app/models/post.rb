class Post < ActiveRecord::Base
  has_many :crushes
  has_many :users, through: :crushes

  validates :content, :fb_created_time, :fb_id, {
    presence: true,
    allow_blank: false,
  }

  def total_tag_count
    self.crushes.inject(0) do |sum,crush|
      sum += crush.num_tags
    end
  end

  # TODO: validate that 1.0 - (sum of all crush quotients) < 0.2 (or other val)

  def fb_url
    FB_URL_BASE + self.fb_id
  end

  def user_highest_score
    # FIXME: placeholder definition
    self.users.first
  end

  def quotients_calc
    # FIXME: what if post contains subset of {first,last,full} name
    
    users_mentioned_full = self.users.find_all do |user|
      self.content.include? user.full_name
    end

    users_mentioned_first = self.users.find_all do |user|
      self.content.include? user.first_name
    end

    users_mentioned_last = self.users.find_all do |user|
      self.content.include? user.last_name
    end
    
    # FIXME: got to be a cleaner way to do this
    post_contains_full_name = users_mentioned_full.any?
    post_contains_first_name = users_mentioned_first.any?
    post_contains_last_name = users_mentioned_last.any?

    if    post_contains_full_name
      primary_user_base = users_mentioned_full
    elsif post_contains_first_name
      primary_user_base = users_mentioned_first
    elsif post_contains_last_name
      primary_user_base = users_mentioned_last
    else
      primary_user_base = []
    end

    every_other_user = self.users.select do |user|
      not primary_user_base.include?(user)
    end

    if not primary_user_base.nil?
      primary_user_base.each do |user|
        crush_curr = Crush.find_by_user_id_and_post_id(user.id, self.id)

        crush_curr.quotient = (Crush.MAX_QUOTIENT_VAL / primary_user_base.length).round 2
      end

      every_other_user.each do |user|
        Crush.find_by_user_id_and_post_id(user.id, self.id).quotient = 0.0
      end
    else
      every_other_user.each do |user|
        Crush.find_by_user_id_and_post_id(user.id, self.id).quotient =
          Crush.MAX_QUOTIENT_VAL / every_other_user.length
      end
    end
  end
  
end
