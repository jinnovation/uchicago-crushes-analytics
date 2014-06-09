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
    # FIXME: account for multiple {first,last,full} name in Post.contents
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

    # FIXME: weight quotient assignment by num_tags
    if primary_user_base.any?
      puts "EVEN DISTRIB PRIMARY_USER_BASE"
      primary_quotient_val_base = (Crush::MAX_QUOTIENT_VAL / primary_user_base.length).round 2
      primary_user_base.each do |user|
        crush_curr = Crush.find_by_user_id_and_post_id(user.id, self.id)

        quotient_old = crush_curr.quotient

        primary_quotient_val_mod = 1.0 # TODO

        crush_curr.quotient = primary_quotient_val_base * primary_quotient_val_mod
        crush_curr.save!
        puts "Crush(#{user.full_name}, #{self.id}).quotient: #{quotient_old}"\
        " => #{crush_curr.quotient}"
      end

      # FIXME: not working for every single case
      puts "EVERY_OTHER_USER.QUOTIENT = 0"
      other_quotient_val = 0.0
      every_other_user.each do |user|
        crush_curr = Crush.find_by_user_id_and_post_id(user.id, self.id)

        quotient_old = crush_curr.quotient
        
        crush_curr.quotient = other_quotient_val
        crush_curr.save!
        puts "Crush(#{user.full_name}, #{self.id}).quotient: #{quotient_old}"\
        " => #{crush_curr.quotient}"
      end
    else

      # FIXME: weight quotient assignment by num_tags
      puts "EVEN DISTRIB TO EVERY_OTHER_USER"

      quotient_val_base = (Crush::MAX_QUOTIENT_VAL / every_other_user.length).round 2

      every_other_user.each do |user|
        crush_curr = Crush.find_by_user_id_and_post_id(user.id, self.id)

        quotient_old = crush_curr.quotient

        quotient_val_mod = 1.0  # TODO
        
        crush_curr.quotient = quotient_val_base * quotient_val_mod
        crush_curr.save!
        puts "Crush(#{user.full_name}, #{self.id}).quotient: #{quotient_old}"\
        " => #{crush_curr.quotient}"
      end
    end
  end
  
end
