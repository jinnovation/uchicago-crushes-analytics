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
        crush_curr = Crush.find_by_user_id_and_post_id(user.id, self.id)

        quotient_old = crush_curr.quotient

        crush_curr.update_attributes quotient: val
        puts "Crush(#{user.full_name}, #{self.id}).quotient: #{quotient_old}"\
        " => #{crush_curr.quotient}"
      end    
  end

  def quotients_calc_from_num_tags(users)
    users_tags_total = users.inject(0) do |sum,user|
      sum += Crush.find_by_user_id_and_post_id(user.id, self.id).num_tags
    end
    
    users.each do |user|
      crush_curr = Crush.find_by_user_id_and_post_id(user.id, self.id)

      quotient_old = crush_curr.quotient
      quotient_new = (crush_curr.num_tags.to_f / users_tags_total.to_f).round 2

      crush_curr.update_attributes quotient: quotient_new
      puts "Crush(#{user.full_name}, #{self.id}).quotient: #{quotient_old}"\
      " => #{crush_curr.quotient}"
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
      puts "DISTRIB PRIMARY_USER_BASE"

      quotients_calc_from_num_tags primary_user_base

      puts "EVERY_OTHER_USER.QUOTIENT = #{0.0}"
      quotients_set_all every_other_user, 0.0
    else
      puts "DISTRIB TO EVERY_OTHER_USER"

      quotients_calc_from_num_tags every_other_user      
    end
  end

end
